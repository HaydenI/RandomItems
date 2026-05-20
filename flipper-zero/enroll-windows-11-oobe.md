# Ducky

```
STRING {email}  
DELAY 100  
ENTER  
DELAY 1500  
STRING {password}  
DELAY 100  
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
  DigiKeyboard.delay(100);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(1500);
  DigiKeyboard.print("{password}");
  DigiKeyboard.delay(100);
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

  delay(100);
  typeKey(KEY_RETURN);

  delay(1500);
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
