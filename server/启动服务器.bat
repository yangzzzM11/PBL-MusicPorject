@echo off
where node 2>nul >nul
if errorlevel 1 (
    bundle\node index.js
) else (
    node index.js
)