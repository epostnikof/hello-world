 #! /bin/bash

#Данные скрипт должен выполнять несколько задач:
# 1.Создать пользователей из списка users.txt
# 2.Задать им пароль из pass.txt
# 3.С помощью sed заменить оболочку c /bin/sh на /bin/bash
# 4.  Записать файл приветствия в домашней директории пользователя, 
#заменив username на имя пользователя.

#Можно начать с того, что для того чтобы создать файл с логинами и паролями пользователей, которые будут читаемыми для программы сhpasswd
#понадобится объеденить файлы users.txt и pass.txt:

#Зададим кое-какие переменные:

 userlist=/home/epostnikof/module_5/homework/users.txt # переменная с ведущая в файл с именами пользователей
 passwdlist=/home/epostnikof/module_5/homework/userpwd_upd # переменная, которая ведёт в файл с который создан для сhpasswd - была добавлена в ходе написания ск>
 passwdetc=/etc/passwd
 usernames=`cat /home/epostnikof/module_5/homework/users.txt | awk '{print $1}'`

        if      
                cat $userlist | awk '{print $1}' > tempfile # из-за того, что в файле users.txt есть второй столбец с комментариями, то предлагаю отсеять второй>
                paste tempfile pass.txt > usrpwd.txt    #объеденим построчно файл логинов и файл паролей в новый файл
        then
                sed 's/ /:/g' usrpwd.txt > userpwd_upd   #создадим файл userpwd_upd, в котором заменим знаки табуляции на двоеточие, для передачи утилите сhpass>
                echo "Пользователи из файла users.txt успешно созданы"
        else
                echo "Пожалуйста, проверьте наличие файлов users.txt и pass.txt"
        fi

# Создадим пользователей с помощью цикла for

        for addusr in `cat $userlist | awk '{print $1}'` # вызываем команду, которая выведет все имена из файла
        do
                useradd -m $addusr #подставляем утилите useradd наши имена пользователя из файла. 
        done

# Зададим пользователям пароль

        if
                chpasswd < userpwd_upd # просто подаём структурированный файл с паролями утилите
        then
                echo "Пароли успешно заданы"
        else

                echo "Ошибка в присвоении паролей"
        fi

#Заменим с помощью sed в /etc/passwd оболочку созданным пользователям 

                sed -n '/user_[1-5]/p' $passwdetc | awk -F: '{print $1}' > tempfile2 # отсеим нужных пользователей и запишем в файл

        for chshell in `cat tempfile2` # исользуем снова цикл for задаём для него переменную
        do
                chsh -s /bin/bash $chshell # меняем оболочку пользователям
                echo "Оболочка изменена на /bin/bash" #
 	done

#Запишем файл приветствия в домашнюю директорию пользователя
        
        for hello in `cat tempfile2`  #
        do 
                mkdir /home/$hello 2> /dev/null # это на случай, если по каким-то причинам папка не создалась, если же она есть, то поток ошибок можно и не пока>
                echo "Greetings!" > /home/$hello/Hello.txt # Просто создаём и записываем в файл
                echo 'Hello '$hello', it nice to meet you' >> /home/$hello/Hello.txt # дописываем в конец файла
        done    
                
                rm tempfile2 # 
                rm usrpwd.txt # Удаляем временные файлы
                rm userpwd_upd #
                rm tempfile #


