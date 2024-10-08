# ToDoList

Тестовое задание


## Задача

Необходимо разработать простое приложение для ведения списка дел (ToDo List) с возможностью добавления, редактирования, удаления задач.
Требования:
 1. Список задач:
   - Отображение списка задач на главном экране;
   - Задача должна содержать название, описание, дату создания и статус (выполнена/не выполнена);
   - Возможность добавления новой задачи;
   - Возможность редактирования существующей задачи;
   - Возможность удаления задачи.
2. Загрузка списка задач из dummyjson api: https://dummyjson.com/todos. При первом запуске приложение должно загрузить список задач из указанного json api.  
 
3. Многопоточность:
- Обработка создания, загрузки, редактирования и удаления задач должна выполняться в фоновом потоке с использованием GCD или NSOperation;
- Интерфейс не должен блокироваться при выполнении операций.

4. CoreData:
- Данные о задачах должны сохраняться в CoreData;
- Приложение должно корректно восстанавливать данные при повторном запуске.


Будет бонусом:
+ Архитектура VIPER: Приложение должно быть построено с использованием архитектуры VIPER. Каждый модуль должен быть четко разделен на компоненты: View, Interactor, Presenter, Entity, Router.
+ Используйте систему контроля версий GIT для разработки.
+ Напишите юнит-тесты для основных компонентов приложения.


## Результат

<img src="https://github.com/KamBik1/ToDoList/blob/main/Screenshots/Screenshot1.png" alt="Screenshot1" width="236" height="510"> <img src="https://github.com/KamBik1/ToDoList/blob/main/Screenshots/Screenshot2.png" alt="Screenshot2" width="236" height="510"> <img src="https://github.com/KamBik1/ToDoList/blob/main/Screenshots/Screenshot3.png" alt="Screenshot3" width="236" height="510">


## Использованный стек технологий

+ UIKit
+ VIPER
+ URLSession
+ Core Data
+ GCD
+ Написаны Unit тесты для модуля Interactor
