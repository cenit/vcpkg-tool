. $PSScriptRoot/../end-to-end-tests-prelude.ps1

$args = $commonArgs + @("--overlay-triplets=$PSScriptRoot/../overlay-triplets/compilertracking", "--overlay-ports=$PSScriptRoot/../e2e-ports", "--binarysource=clear;files,$ArchiveRoot,readwrite")

# Test simple installation
Run-Vcpkg -TestArgs ($args + @("install", "vcpkg-hello-world-1"))
Throw-IfFailed
if (-Not (select-string "^triplet_abi [0-9a-f]+-[0-9a-f]+-[0-9a-f]+$" "$installRoot/$Triplet/share/vcpkg-hello-world-1/vcpkg_abi_info.txt")) {
    throw "Expected vcpkg-hello-world-1 to perform compiler detection"
}
Remove-Item -Recurse -Force $installRoot

Run-Vcpkg -TestArgs ($args + @("install", "vcpkg-hello-world-2"))
Throw-IfFailed
if (-Not (select-string "^triplet_abi [0-9a-f]+-[0-9a-f]+$" "$installRoot/$Triplet/share/vcpkg-hello-world-2/vcpkg_abi_info.txt")) {
    throw "Expected vcpkg-hello-world-2 to not perform compiler detection"
}
Remove-Item -Recurse -Force $installRoot

Run-Vcpkg -TestArgs ($args + @("install", "vcpkg-hello-world-2", "vcpkg-hello-world-1"))
Throw-IfFailed
if (-Not (select-string "^triplet_abi [0-9a-f]+-[0-9a-f]+-[0-9a-f]+$" "$installRoot/$Triplet/share/vcpkg-hello-world-1/vcpkg_abi_info.txt")) {
    throw "Expected vcpkg-hello-world-1 to perform compiler detection"
}
if (-Not (select-string "^triplet_abi [0-9a-f]+-[0-9a-f]+$" "$installRoot/$Triplet/share/vcpkg-hello-world-2/vcpkg_abi_info.txt")) {
    throw "Expected vcpkg-hello-world-2 to not perform compiler detection"
}
