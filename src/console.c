#include "console.h"

UINT32 PrintFormatedString(const PCHAR format, ...){

    VA_LIST args; // Variatic arguments list
    
   

    VA_START(args, format); // Initialize the argument list with format so we can access the variable arguments
    
    CHAR   buffer[1024]; // Buffer to hold the formatted string

    

    INT32 len = String_FormatV(buffer, format, args); // Format the string using the variable arguments
    VA_END(args); // Clean up the argument list

    return WriteConsole(buffer, len); // Write the formatted string to the console and return the number of characters written
}