#ifndef __PRIMITIVES_H__
#define __PRIMITIVES_H__

#if !defined(__llvm__) && !defined(__clang__)
	#error "Only Clang/LLVM compiler is supported!"
#endif

#define NO_RETURN  __attribute__((noreturn))

#if defined(PLATFORM_WINDOWS)
	#define ENTRYPOINT __attribute__((section(".text$main")))
#elif defined(PLATFORM_LINUX)
	#define ENTRYPOINT __attribute__((section(".text$main"))) __attribute__((noreturn))
#endif

#define TRUE    ((BOOL)1)
#define FALSE   ((BOOL)0)
#define NULL    ((PVOID)0)

typedef void VOID, * PVOID,** PPVOID;

typedef signed char INT8, * PINT8;
typedef unsigned char UINT8, * PUINT8, ** PPUINT8;

typedef signed short INT16, * PINT16;
typedef unsigned short UINT16, * PUINT16;

typedef signed int INT32, * PINT32;
typedef unsigned int UINT32, * PUINT32, ** PPUINT32;

typedef signed long long INT64, * PINT64;
typedef unsigned long long UINT64, * PUINT64,** PPUINT64;

typedef char CHAR, * PCHAR, ** PPCHAR;
typedef unsigned char UCHAR, * PUCHAR;

//typedef float FLOAT, * PFLOAT;
typedef double DOUBLE, * PDOUBLE;

#if defined(PLATFORM_WINDOWS)
    typedef UINT16 WCHAR, * PWCHAR, ** PPWCHAR;
    typedef INT32 BOOL, * PBOOL,** PPBOOL;
#elif defined(PLATFORM_LINUX)
    typedef INT32 WCHAR, * PWCHAR, ** PPWCHAR;
    typedef UINT8 BOOL, * PBOOL,** PPBOOL;
#else
    #error Unsupported platform
#endif

#if defined(ARCHITECTURE_AMD64) || defined(ARCHITECTURE_ARM64)
    typedef UINT64 USIZE , * PUSIZE;
    typedef INT64 SSIZE , * PSSIZE;
#else
    typedef UINT32 USIZE , * PUSIZE;
    typedef INT32 SSIZE , * PSSIZE;
#endif 

#define VA_LIST                 __builtin_va_list
#define VA_START(ap, v)			__builtin_va_start(ap, v)
#define VA_ARG(ap, t)			__builtin_va_arg(ap, t)
#define VA_END(ap)				__builtin_va_end(ap)

#endif // __PRIMITIVES_H__
