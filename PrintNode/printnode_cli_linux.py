#!/usr/bin/env python3

import json
import os
import subprocess as sp
import sys
import time

import click
import colorama
import configupdater
import psutil
from PyInquirer import prompt

from pylib import pchmod

####
#
printnode_config='/etc/PrintNode/config.conf'
printnode_json='/etc/PrintNode/printnode/11/configuration.json'
printnode_init='/etc/init.d/PrintNode'

#
####
## Todo - add cli option for displaying current config? 
## Including ability to show current printer IDs easily

q = []
env_email = os.environ.get('PRINTNODE_EMAIL')
env_password = os.environ.get('PRINTNODE_PASSWORD')
env_computer_name = os.environ.get('PRINTNODE_COMPUTER_NAME')

if not env_email:
    q.append({
        'type': 'input',
        'name': 'account_email',
        'message': 'Please enter the PrintNode account username: '
    })
if not env_password:
    q.append({
        'type': 'password',  # Mask input typing for password
        'name': 'account_password',
        'message': 'Please enter the PrintNode account password: '
    })
if not env_computer_name:
    q.append({
        'type': 'input',
        'name': 'computer_name',
        'message': 'Please enter the location (computer name override): '
    })

qConfirm = [{ 'type': 'confirm', 'name': 'confirm_result', 'message': 'Are these values correct? ', 'default': False}]


def checkPrintNodeRunning():
    isRunning = False
    #for p in psutil.process_iter():
        #if p.name().lower() == 'printnode':
            #isRunning = True

    return isRunning


cp = configupdater.ConfigUpdater() 
cp.read(printnode_config)

if len(cp.sections()) <= 0:
    #raise Exception("Cannot open /etc/PrintNode/config.conf") 
    click.echo(click.style("ERROR: Cannot open " + printnode_config, fg='red', underline=True, bold=True))
    sys.exit(1)

ans = {}
if q:
    ans = prompt(q)
    # Merge interactive answers with environment variables if any was skipped
    if 'account_email' not in ans and env_email:
        ans['account_email'] = env_email
    if 'account_password' not in ans and env_password:
        ans['account_password'] = env_password
    if 'computer_name' not in ans and env_computer_name:
        ans['computer_name'] = env_computer_name
else:
    ans['account_email'] = env_email
    ans['account_password'] = env_password
    ans['computer_name'] = env_computer_name

# If any values were gathered interactively, print them (masking the password) and ask for confirmation.
is_interactive = len(q) > 0

if is_interactive:
    click.echo("")
    click.echo("\t\t" + click.style("Account Username:", fg='bright_white', underline=True) + "\t\t" + click.style(ans.get('account_email', ''), fg='green', bold=True))
    click.echo("\t\t" + click.style("Account Password:", fg='bright_white', underline=True) + "\t\t" + click.style("********", fg='green', bold=True))
    click.echo("\t\t" + click.style("Computer Name/Location:", fg='bright_white', underline=True) + "\t\t" + click.style(ans.get('computer_name', ''), fg='yellow', bold=True))
    click.echo("")
    click.echo("")
    proceed=prompt(qConfirm)

    if proceed.get('confirm_result') != True:
        click.echo(click.style("Cancelling changes... exiting.", fg='yellow'))
        sys.exit(2)
else:
    click.echo(click.style("Loaded all configuration values from environment variables.", fg='green'))

if checkPrintNodeRunning():
    shutReturn = sp.call(['systemctl', 'stop', 'PrintNodeRec'])
    if shutReturn != 0:
        click.echo(click.style("WARNING: Unable to stop PrintNode... please try stopping manually (systemctl stop PrintNode)", fg='red', bold=True, underline=True))
    #    sys.exit(1)
    if checkPrintNodeRunning():
        click.echo(click.style("ERROR: Printnode still running after trying to stop...  please try stopping manually (systemctl stop printnode)", fg='red', bold=True, underline=True))
        sys.exit(1)

    
click.echo(click.style("Proceeding to change configuration", fg='bright_white'))
#PrintNode complains about having this here
#cp.set('credentials', 'use_environment_variables', 'no')
cp.set('credentials', 'email', ans['account_email'])
cp.set('credentials', 'password', ans['account_password'])
cp.set('computer', 'name', ans['computer_name'])

fOut=open(printnode_config, 'w')

cp.write(fOut)

fOut.close()

# Secure configuration file permissions (chmod 600) so only the owner can read/write it
try:
    os.chmod(printnode_config, 0o600)
    click.echo(click.style("Secured configuration file permissions (chmod 600)", fg='green'))
except Exception as e:
    click.echo(click.style(f"Notice: Could not set file permissions (chmod 600) on config file: {e}", fg='yellow'))

click.echo(click.style("Wrote configuration to " + printnode_config, fg='green'))

#init_status = pchmod.SmartPath(printnode_init)

qPermsConfirm = [{ 'type': 'confirm', 
                   'name': 'confirm_result', 
                   'message': 'Do you want to enable the PrintNode service «If you say no, this script will end…»  ? ', 
                   'default': False}]

#chmod
chownStatus = sp.call(['chown', '-R', 'printnode:printnode', '/etc/PrintNode'])
chownStatus = sp.call(['chown', '-R', 'printnode:printnode', '/var/log/printnode'])

printNodeServiceEnabled = sp.getoutput(['systemctl is-enabled PrintNode'])

if printNodeServiceEnabled.strip().lower() == 'disabled':
    #prompt and set
    click.echo(click.style("PrintNode is not currently set to start automatically.", fg='yellow'))
    permsConfirm=prompt(qPermsConfirm)
    if permsConfirm['confirm_result'] == False:
        click.echo(click.style("Not enabling the PrintNode service…", fg='yellow'))
        click.echo(click.style("Unable to proceed, aborting…", fg='red'))
        sys.exit(1)

    click.echo(click.style("Enabling the PrintNode service…"))
    #init_status.file_perms.all_exec = True
    #init_status.file_perms_write()
    time.sleep(1)
    sReload1 = sp.call(['systemctl', 'daemon-reload'])
    time.sleep(1)
    sEnable1 = sp.call(['systemctl', 'enable', 'PrintNode'])
    time.sleep(1)    


click.echo(click.style("Waiting for a few seconds..."))
time.sleep(1.5)

click.echo(click.style("Restarting PrintNode.... (this may take a little bit... will wait for 30 seconds)"))

restartWait = 60
restartLoopDelay = 1
restartWaited = 0
restarted = False
restartMinDelay = 30


restartReturn = sp.call(['systemctl', 'restart', 'PrintNode'])
if restartReturn != 0:
    click.echo(click.style("NOTICE: Possible issue restarting PrintNode from systemctl\n -- Will wait and see if service starts...", fg='yellow'))

while restarted == False:
    pnIsRunning = checkPrintNodeRunning()
    if pnIsRunning and restartWaited > restartMinDelay:
        restarted = True
        continue
    else:
        time.sleep(restartLoopDelay)
        restartWaited += 1
    if restartWaited % 5 == 0: 
        click.echo(click.style("Waited " + str(restartWaited) + " of " +str(restartWait) +"s...", fg='bright_white'))
    if restartWaited > restartWait:
        click.echo(click.style("ERROR: Timeout after 30s waiting for PrintNode to start, please check the logs and restart manually", fg='red', bold=True, underline=True))
        sys.exit(1)

#if restartReturn != 0:
#elif checkPrintnodeRunning
#time.sleep(5)

if checkPrintNodeRunning() == False:
    click.echo(click.style("ERROR: Printnode did not startup properly, please check the logs and restart manually", fg='red', bold=True, underline=True))
    sys.exit(1)

try:
    jIn = open(printnode_json, 'r') 
    jsonPN = json.load(jIn)
    jIn.close()

    starTSP_pnID = jsonPN['printer_settings']['ids']['StarTSP100']
except Exception as e:
    click.echo("Error accessing PrintNode printer data - There might be a problem with CUPS...")
    click.echo(e)
    sys.exit(1)


click.echo()
click.echo(click.style("Setup complete!\n\n", fg='green'))
click.echo("The new printer ID in PrintNode is: " + click.style(str(starTSP_pnID), fg='bright_cyan', bold=True, underline=True))
