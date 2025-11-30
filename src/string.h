#ifndef __STRING_H__
#define __STRING_H__

#include "primitives.h"


#define towlower(c) (((c) >= L'A' && (c) <= L'Z') ? ((c) + (L'a' - L'A')) : (c))
#define TO_LOWER_CASE(c) (((c) >= 'A' && (c) <= 'Z') ? ((c) + ('a' - 'A')) : (c))

// Case-insensitive string comparison
BOOL CompareStringIgnoreCase(const PCHAR s1, const PCHAR s2);

// Case-insensitive wide string comparison
BOOL CompareWideStringIgnoreCase(const PWCHAR s1, const PWCHAR s2);

// Get the length of a null-terminated string
USIZE GetStringLength(const PCHAR str);

INT32 String_FormatV(PCHAR s, PCHAR format, VA_LIST args);

#endif // __STRING_H__