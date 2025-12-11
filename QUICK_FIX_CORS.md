# Быстрое решение проблемы CORS

## Проблема
Ошибка: "Ошибка сети проверьте подключение к интернету и CORS настройки"

## Решение (для разработки)

### Windows:

1. **Закройте все окна Chrome**

2. **Откройте PowerShell или CMD и выполните:**
   ```cmd
   start chrome.exe --user-data-dir="C:/temp/chrome_dev_session" --disable-web-security --disable-features=VizDisplayCompositor
   ```

3. **Или запустите скрипт:**
   - Дважды кликните на `scripts/run_chrome_no_cors.bat`

4. **Затем запустите приложение:**
   ```bash
   flutter run -d chrome
   ```

### Linux/Mac:

1. **Закройте все окна Chrome**

2. **Выполните в терминале:**
   ```bash
   google-chrome --user-data-dir="/tmp/chrome_dev_session" --disable-web-security --disable-features=VizDisplayCompositor &
   ```

3. **Или запустите скрипт:**
   ```bash
   chmod +x scripts/run_chrome_no_cors.sh
   ./scripts/run_chrome_no_cors.sh
   ```

4. **Затем запустите приложение:**
   ```bash
   flutter run -d chrome
   ```

## ⚠️ ВАЖНО

- Используйте этот метод **ТОЛЬКО для разработки**
- **НЕ используйте** этот браузер для обычного просмотра
- После разработки закройте этот экземпляр Chrome

## Альтернатива: Проверка API

Перед запуском проверьте, что API доступны:

1. Откройте в браузере: https://reqres.in/api/users?page=1
2. Должен вернуться JSON (без ошибок CORS)
3. Если есть ошибка CORS - используйте метод выше

## Если проблема сохраняется

1. Проверьте консоль браузера (F12)
2. Проверьте вкладку Network для деталей запросов
3. Убедитесь, что используете правильные тестовые данные:
   - Вход: `eve.holt@reqres.in` / `cityslicka`
   - Регистрация: `eve.holt@reqres.in` / `pistol`


