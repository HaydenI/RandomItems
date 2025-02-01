# Ducky

```
STRING {email}  
ENTER  
DELAY 2500  
TAB  
DELAY 100  
TAB  
DELAY 100  
TAB  
DELAY 100  
TAB  
DELAY 100  
STRING {password}  
ENTER  
DELAY 2500  
ENTER  
```

# Digi

Converted using digiQuack by CedArctic ([GitHub link](https://github.com/CedArctic/digiQuack)) 

```cpp
#include "DigiKeyboard.h"

void setup() {}

void loop() {
  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.print("{email}");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(2500);
  DigiKeyboard.sendKeyStroke(43);
  DigiKeyboard.delay(100);
  DigiKeyboard.sendKeyStroke(43);
  DigiKeyboard.delay(100);
  DigiKeyboard.sendKeyStroke(43);
  DigiKeyboard.delay(100);
  DigiKeyboard.sendKeyStroke(43);
  DigiKeyboard.delay(100);
  DigiKeyboard.print("{password}");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(2500);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
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

  Keyboard.print(F("{email}"));

  typeKey(KEY_RETURN);

  delay(2500);
  typeKey(KEY_TAB);

  delay(100);
  typeKey(KEY_TAB);

  delay(100);
  typeKey(KEY_TAB);

  delay(100);
  typeKey(KEY_TAB);

  delay(100);
  Keyboard.print(F("{password}"));

  delay(100);
  typeKey(KEY_RETURN);

  delay(2500);
  typeKey(KEY_RETURN);

  // Ending stream
  Keyboard.end();
}

/* Unused endless loop */
void loop() {}
```
