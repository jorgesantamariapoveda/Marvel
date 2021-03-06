# Marvel
Listado de los personajes Marvel y permitir ver el detalle de cada uno de ellos de manera individual.

API de Marvel: [https://developer.marvel.com/docs](https://developer.marvel.com/docs). Es necesario registrarse (gratuito).

## Funcionalidad
- Listado de los personajes (/v1/public/characters)
- Navegar al detalle de un personaje concreto (/v1/public/characters/{characterid})

## Comentarios
- Las dos arquitecturas nativas de Apple son:
	1. MVC para UIKit (el empleado en este caso práctico).
	2. MVVM para SwiftUI.

- Tras el registro en la web de Marvel para desarrolladores se necesita un hash MD5. Obtenido con ayuda del siguiente recurso: [https://www.md5hashgenerator.com/](https://www.md5hashgenerator.com/)

- Para las pruebas de las peticiones a la API he empleado [Postman](https://www.postman.com/)

- He optado por definir todos los atributos de los structs que van a definir el modelo como opcionales, de ese modo en caso de que alguno llegase incorrecto no perdería toda la decodificación del JSON.

- Las peticiones a red tienen que ser por https, por lo que para la obtención de las imágenes he tenido que modificar el path que devuelve el API de Marvel en el momento de realizar las peticiones.

- Para las imágenes hay diferentes tamaños como se indica en [developer.marvel.com/documentation/images](https://developer.marvel.com/documentation/images). He empleado dicha característica para mostrar en un tamaño pequeño las imágenes de los personajes en la vista principal y otro más grande para la vista detalle.