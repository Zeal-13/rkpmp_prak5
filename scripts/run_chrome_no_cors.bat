@echo off
REM Запуск Chrome с отключенной проверкой CORS для разработки
REM ВНИМАНИЕ: Используйте только для разработки!

start chrome.exe --user-data-dir="C:/temp/chrome_dev_session" --disable-web-security --disable-features=VizDisplayCompositor --remote-debugging-port=9222

echo Chrome запущен с отключенной проверкой CORS
echo Теперь запустите приложение: flutter run -d chrome


