======================================================
GUÍA PARA GITHUB - PROYECTO REFACCIONARIA
======================================================

REGLAS:
1. NUNCA programar directamente en la rama "main".
2. NUNCA programar directamente en la rama "develop".
3. NUNCA apruebes tu propio código. Alguien más debe revisarlo.

------------------------------------------------------
CÓMO TRABAJAR EN UNA TARJETA DE TRELLO (Paso a Paso)
------------------------------------------------------

PASO 1: Bajar lo más nuevo (Haz esto ANTES de empezar a programar)
Abre tu terminal y asegúrate de estar en develop y con el código actualizado de los demás:
> git checkout develop
> git pull origin develop

PASO 2: Crear tu propia rama de trabajo (Tu mesa separada)
Crea una rama con el nombre de lo que vas a hacer. Usa "feature/" al inicio:
> git checkout -b feature/nombre-de-tu-tarea
(Ejemplo: git checkout -b feature/login-flutter)

PASO 3: ¡A programar!
Abre tu editor, escribe tu código en tu respectiva carpeta (backend-sql, frontend-web, etc.), y pruébalo.

PASO 4: Guardar tus cambios localmente
Cuando tu código ya funcione, guárdalo con un mensaje claro que indique qué tarjeta de Trello hiciste:
> git add .
> git commit -m "Termine HU01: Diseño de pantalla de login en Flutter"

PASO 5: Subir tu rama a la nube (GitHub)
Sube tu rama para que los demás la vean:
> git push origin feature/nombre-de-tu-tarea
(Ejemplo: git push origin feature/login-flutter)

PASO 6: Crear el Pull Request (En GitHub)
1. Entra a la página del repositorio en GitHub.
2. Verás un botón verde que dice "Compare & pull request". Dale clic.
3. Asegúrate de que diga que vas a mezclar tu rama hacia "develop" (¡NO hacia main!).
4. Escribe un comentario de lo que hiciste y dale a "Create pull request".

PASO 7: La Revisión (El Desarrollo Horizontal)
1. Avisa por WhatsApp: "Oigan, ya subí el Parte de la tarea X, ¿quién me lo revisa?".
2. Quien NO haya escrito el código subido previamente entra a GitHub (El que lo escribió NO, lo tiene que revisar otra persona), revisa que todo esté bien y le da clic al botón verde "Merge pull request".
3. ¡Listo! El código ya forma parte de develop.

PASO 8: Limpiar tu computadora
Una vez que tu código fue aceptado y fusionado en develop, regresa a develop y borra tu rama local para no acumular basura:
> git checkout develop
> git pull origin develop
> git branch -d feature/nombre-de-tu-tarea

¡Y repites el ciclo con la siguiente tarjeta de Trello!

