# flutter_settings_screens_test

    Program to test flutter_settings_screens.

    Trying to offer two radio button choices to the user, 
    A and B, and based on which option they select, we need
    to present either two text input fields (A1 and A2),
    or onetext input field (B).

    I'm not able to make this work.  I have a setState() 
    call in the onChanged event for the radio button,
    I have unique ValueKeys in each of the 3 text
    input fields, and even tried a "refreshable" 
    UniqueKey in the column widget that contains the
    radio tile and the 3 text input tiles.

    If you click outside the settings dialog, and go
    back in, the correct text input tiles are visible,
    and any text you type in will be properly saved
    as part of that widget's state.

    But nothing I've tried triggers an update of the
    screen in response to the radio button change.
