import '../../models/content_block.dart';

const Map<int, List<ContentBlock>> enrichedLessons = {
  // ===== MÓDULO 1: Introducción a Python =====
  1: [
    ContentBlock(type: 'text', value: 'Python es un lenguaje de programación de alto nivel, interpretado y de propósito general. Fue creado por Guido van Rossum y lanzado por primera vez en 1991. Su diseño se centra en la legibilidad del código, utilizando una sintaxis clara y expresiva.'),
    ContentBlock(type: 'text', value: 'Una de las características más importantes de Python es que utiliza indentación (sangrado) para definir bloques de código, a diferencia de otros lenguajes que usan llaves {}. Esto obliga a escribir código limpio y bien estructurado desde el principio.'),
    ContentBlock(type: 'code', value: '# Esto es un bloque de código en Python\n# La indentación define la estructura\n\nif True:\n    print("Este texto está dentro del if")\n    print("También está dentro")\nprint("Este está fuera del if")'),
    ContentBlock(type: 'text', value: 'Python es utilizado en una gran variedad de áreas:\n\n• Desarrollo web (Django, Flask)\n• Ciencia de datos y machine learning\n• Automatización y scripts\n• Inteligencia artificial\n• Desarrollo de juegos\n• Aplicaciones de escritorio'),
    ContentBlock(type: 'text', value: 'Ventajas principales de Python:\n\n• Sintaxis sencilla y legible: Ideal para principiantes.\n• Gran comunidad: Millones de desarrolladores comparten librerías y soluciones.\n• Multiplataforma: Funciona en Windows, macOS y Linux.\n• Tipado dinámico: No necesitas declarar el tipo de las variables.\n• Amplia biblioteca estándar: Viene con muchas herramientas incluidas.'),
    ContentBlock(type: 'code', value: '# Python se puede usar como calculadora\nprint(2 + 3)        # Suma: 5\nprint(10 - 4)       # Resta: 6\nprint(3 * 7)        # Multiplicación: 21\nprint(15 / 3)       # División: 5.0\nprint(15 // 3)      # División entera: 5\nprint(10 % 3)       # Módulo (resto): 1\nprint(2 ** 3)       # Potencia: 8'),
  ],
  2: [
    ContentBlock(type: 'text', value: 'Para empezar a programar en Python, necesitas tenerlo instalado en tu computadora. Existen dos versiones principales: Python 2 (obsoleto) y Python 3 (recomendado). Siempre debes usar Python 3.'),
    ContentBlock(type: 'text', value: 'Puedes descargar Python desde el sitio oficial python.org. El instalador incluye IDLE, un entorno de desarrollo básico, y pip, el gestor de paquetes de Python.'),
    ContentBlock(type: 'text', value: 'Formas de ejecutar código Python:\n\n1. Intérprete interactivo: Escribes python en la terminal y puedes probar comandos uno por uno.\n2. Archivos .py: Escribes tu código en un archivo y lo ejecutas con python archivo.py.\n3. Entornos de desarrollo (IDE): Como PyCharm, VS Code, o Thonny.\n4. Notebooks: Como Jupyter Notebook, muy usado en ciencia de datos.'),
    ContentBlock(type: 'code', value: '# Primer programa en Python\n# Guarda esto en un archivo llamado hola.py\n\nprint("¡Hola, mundo!")'),
    ContentBlock(type: 'text', value: 'Para ejecutar tu programa:\n\n• Abre una terminal o símbolo del sistema\n• Navega hasta la carpeta donde guardaste el archivo\n• Escribe: python hola.py\n• Presiona Enter y verás: ¡Hola, mundo!'),
    ContentBlock(type: 'code', value: '# Cómo verificar tu versión de Python\nimport sys\nprint(f"Versión de Python: {sys.version}")'),
  ],
  3: [
    ContentBlock(type: 'text', value: 'Vamos a escribir nuestro primer programa en Python. Tradicionalmente, el primer programa que se escribe en cualquier lenguaje es "¡Hola, mundo!", que simplemente muestra un mensaje en pantalla.'),
    ContentBlock(type: 'text', value: 'La función print() es la forma más básica de mostrar información en Python. Puedes imprimir texto, números, resultados de operaciones y mucho más.'),
    ContentBlock(type: 'code', value: '# Tu primer programa\nprint("¡Hola, mundo!")'),
    ContentBlock(type: 'text', value: 'print() puede recibir múltiples valores separados por comas. Automáticamente los separa con un espacio al mostrarlos.'),
    ContentBlock(type: 'code', value: '# Múltiples valores en print\nprint("Hola", "mundo", "desde", "Python")\nprint("El resultado de 5 + 3 es:", 5 + 3)'),
    ContentBlock(type: 'text', value: 'Puedes personalizar el separador entre valores usando sep y el final del mensaje usando end:'),
    ContentBlock(type: 'code', value: '# Personalizando print\nprint("Python", "es", "genial", sep=" - ")\nprint("Primera línea", end=" - ")\nprint("Segunda línea")'),
  ],
  4: [
    ContentBlock(type: 'text', value: 'Los comentarios son notas que el programador escribe en el código para explicar qué hace cada parte. Python ignora completamente los comentarios al ejecutar el programa.'),
    ContentBlock(type: 'text', value: 'En Python hay dos tipos de comentarios:\n\n• Comentarios de una línea: Usan el símbolo #\n• Comentarios de múltiples líneas: Usan triple comilla (""" o \'\'\')'),
    ContentBlock(type: 'code', value: '# Esto es un comentario de una línea\nprint("Hola")  # También puedes poner comentarios al final\n\n"""\nEsto es un comentario\nque ocupa múltiples\nlíneas.\n"""\n\nprint("El código sigue funcionando")'),
    ContentBlock(type: 'text', value: 'Los buenos comentarios explican el POR QUÉ del código, no el QUÉ. El código ya dice lo que hace. Los comentarios deben explicar por qué se eligió cierta solución o algoritmo.'),
    ContentBlock(type: 'code', value: '# MAL comentario:\n# Suma a y b y guarda el resultado en c\nc = a + b\n\n# BUEN comentario:\n# Usamos suma en lugar de multiplicación porque\n# necesitamos combinar valores no duplicados\nc = a + b'),
  ],
  5: [
    ContentBlock(type: 'text', value: 'Al programar, cometer errores es normal y forma parte del aprendizaje. Python te ayuda mostrando mensajes de error que indican qué salió mal y en qué línea.'),
    ContentBlock(type: 'text', value: 'Los tipos de errores más comunes son:\n\n• SyntaxError: Error de sintaxis (olvidaste algo)\n• NameError: Usaste una variable que no existe\n• TypeError: Operación entre tipos incompatibles\n• IndexError: Accediste a un índice fuera de rango\n• ZeroDivisionError: Dividiste por cero'),
    ContentBlock(type: 'code', value: '# Error de sintaxis: falta cerrar paréntesis\n# print("Hola"\n\n# Error de nombre: la variable no está definida\n# print(mensaje)\n\n# Error de tipo: no se puede sumar texto y número\n# print("La respuesta es " + 42)'),
    ContentBlock(type: 'text', value: 'Cuando veas un error, lee el mensaje con atención. Python te dice:\n\n1. El tipo de error (ej: SyntaxError)\n2. Una descripción del problema\n3. La línea exacta donde ocurrió\n4. Una flecha (^) señalando el lugar exacto'),
    ContentBlock(type: 'code', value: "# Así se ve un error típico:\n# Traceback (most recent call last):\n#   File \"programa.py\", line 2, in <module>\n#     print(\"Hola\"\n#           ^\n# SyntaxError: '(' was never closed"),
  ],

  // ===== MÓDULO 2: Variables =====
  6: [
    ContentBlock(type: 'text', value: 'Las variables son como "cajas" donde guardamos información para usarla después. En Python, las variables se crean en el momento en que les asignas un valor, sin necesidad de declararlas primero.'),
    ContentBlock(type: 'text', value: 'A diferencia de otros lenguajes, Python es de tipado dinámico. Esto significa que no necesitas especificar el tipo de dato que va a almacenar la variable; Python lo deduce automáticamente.'),
    ContentBlock(type: 'code', value: '# Creando variables en Python\nnombre = "Ana"        # Variable de texto (string)\nedad = 25             # Variable entera (int)\naltura = 1.68         # Variable decimal (float)\nes_estudiante = True  # Variable booleana (bool)\n\nprint(nombre, edad, altura, es_estudiante)'),
    ContentBlock(type: 'text', value: 'El signo = es el operador de asignación. No debes confundirlo con el signo == que se usa para comparar. La variable siempre va a la izquierda y el valor a la derecha.'),
    ContentBlock(type: 'code', value: '# Así NO se escribe una variable:\n# 123edad = 10  # Error: no puede empezar con número\n# mi-edad = 10   # Error: guiones no permitidos\n# mi edad = 10   # Error: espacios no permitidos\n\n# Así SÍ se escribe correctamente:\nmi_edad = 10       # Usa guión bajo\nmiEdad = 10        # CamelCase también funciona\nMI_EDAD = 10       # Mayúsculas para constantes'),
  ],
  7: [
    ContentBlock(type: 'text', value: 'La asignación es la operación fundamental para trabajar con variables. Consiste en guardar un valor en una variable usando el operador =.'),
    ContentBlock(type: 'text', value: 'Puedes asignar valores de diferentes formas:\n\n• Asignación simple: x = 5\n• Asignación múltiple: a, b = 10, 20\n• Asignación del mismo valor: x = y = z = 0\n• Asignación con expresión: resultado = (5 + 3) * 2'),
    ContentBlock(type: 'code', value: '# Diferentes formas de asignación\n\n# Simple\nnombre = "Carlos"\n\n# Múltiple\nx, y, z = 10, 20, 30\nprint(x, y, z)  # 10 20 30\n\n# Mismo valor\na = b = c = 0\nprint(a, b, c)  # 0 0 0'),
    ContentBlock(type: 'text', value: 'Puedes intercambiar el valor de dos variables fácilmente en Python, algo que en otros lenguajes requiere una variable temporal:'),
    ContentBlock(type: 'code', value: '# Intercambio de variables (swap)\na = 5\nb = 10\nprint(f"Antes: a={a}, b={b}")\n\na, b = b, a  # Así de fácil se intercambia\n\nprint(f"Después: a={a}, b={b}")'),
  ],
  8: [
    ContentBlock(type: 'text', value: 'Las reglas para nombrar variables en Python son importantes de conocer:\n\n• Pueden contener letras, números y guiones bajos\n• Deben empezar con una letra o guión bajo\n• Distinguen mayúsculas y minúsculas (edad ≠ Edad)\n• No pueden usar palabras reservadas del lenguaje'),
    ContentBlock(type: 'code', value: '# Nombres válidos\nmi_variable = 1\n_variable_privada = 2\nvariable123 = 3\nnombreUsuario = 4\n\n# Nombres NO válidos (darán error)\n# 1variable = 10    # Empieza con número\n# mi-variable = 10  # Contiene guión\n# class = 10        # Palabra reservada'),
    ContentBlock(type: 'text', value: 'Convenciones de nombres (buenas prácticas):\n\n• Variables: usar snake_case (mi_variable)\n• Constantes: usar MAYÚSCULAS (PI = 3.1416)\n• Clases: usar CamelCase (MiClase)\n• Nombres descriptivos y en inglés o español, pero consistentes'),
    ContentBlock(type: 'code', value: '# Buenas prácticas al nombrar variables\n\n# Malos nombres (no dicen nada)\nx = 5\ny = "Juan"\nz = 3.14\n\n# Buenos nombres (describen el contenido)\nedad_usuario = 5\nnombre_completo = "Juan"\nvalor_pi = 3.14'),
  ],
  9: [
    ContentBlock(type: 'text', value: 'Las variables en Python pueden cambiar de valor durante la ejecución del programa. A esto se le llama reasignación. Incluso pueden cambiar de tipo.'),
    ContentBlock(type: 'code', value: '# Reasignación de variables\nvalor = 10\nprint(f"Primer valor: {valor}")  # 10\n\nvalor = 25\nprint(f"Segundo valor: {valor}")  # 25\n\nvalor = "ahora soy texto"\nprint(f"Tercer valor: {valor}")  # ahora soy texto'),
    ContentBlock(type: 'text', value: 'Puedes usar el valor actual de una variable para calcular su nuevo valor. Esto es muy común en contadores y acumuladores:'),
    ContentBlock(type: 'code', value: '# Usando el valor actual para calcular el nuevo\ncontador = 0\ncontador = contador + 1  # Incremento\nprint(contador)           # 1\n\ncontador = contador + 5\nprint(contador)           # 6\n\n# Forma abreviada (operadores de asignación)\ncontador += 1   # Equivale a: contador = contador + 1\ncontador -= 3   # Equivale a: contador = contador - 3\ncontador *= 2   # Equivale a: contador = contador * 2\ncontador /= 2   # Equivale a: contador = contador / 2'),
  ],
  10: [
    ContentBlock(type: 'text', value: 'Python permite asignar valores a múltiples variables en una sola línea. Esto hace el código más compacto y legible.'),
    ContentBlock(type: 'code', value: '# Asignación múltiple\nnombre, edad, ciudad = "María", 22, "Madrid"\nprint(f"Me llamo {nombre}, tengo {edad} años y vivo en {ciudad}")'),
    ContentBlock(type: 'text', value: 'También puedes asignar el mismo valor a varias variables a la vez. Esto es útil para inicializar varias variables con un valor por defecto:'),
    ContentBlock(type: 'code', value: '# Mismo valor para múltiples variables\na = b = c = d = 0\nprint(a, b, c, d)  # 0 0 0 0\n\n# Útil para inicializar contadores\naprobados = reprobados = pendientes = 0'),
    ContentBlock(type: 'code', value: '# Desempaquetado de colecciones\ncoordenadas = (10, 20)\nx, y = coordenadas\nprint(f"x={x}, y={y}")  # x=10, y=20\n\nlista = [1, 2, 3]\nprimero, segundo, tercero = lista\nprint(primero, segundo, tercero)  # 1 2 3'),
  ],

  // ===== MÓDULO 3: Tipos de datos =====
  11: [
    ContentBlock(type: 'text', value: 'Los números son uno de los tipos de datos fundamentales en Python. Hay dos tipos principales: enteros (int) y decimales (float).'),
    ContentBlock(type: 'code', value: '# Números enteros (int)\nedad = 25\npoblacion = 8_000_000_000  # Los guiones mejoran la lectura\ntemperatura = -5\n\nprint(type(edad))  # <class \'int\'>'),
    ContentBlock(type: 'code', value: '# Números decimales (float)\npi = 3.1416\ngravedad = 9.81\nprecio = 19.99\nnotacion_cientifica = 1.5e10  # 1.5 × 10^10\n\nprint(type(pi))  # <class \'float\'>'),
    ContentBlock(type: 'text', value: 'Los números float tienen precisión limitada. Por eso, al hacer operaciones con decimales, a veces obtienes resultados como 0.30000000000000004 en lugar de 0.3. Esto es normal en computación.'),
    ContentBlock(type: 'code', value: '# Precisión de float\nprint(0.1 + 0.2)  # 0.30000000000000004\n\n# Para cálculos precisos con dinero, usa Decimal\nfrom decimal import Decimal\nprint(Decimal(\'0.1\') + Decimal(\'0.2\'))  # 0.3'),
  ],
  12: [
    ContentBlock(type: 'text', value: 'Las cadenas de texto (strings) se usan para almacenar y manipular texto. Se escriben entre comillas simples (\') o dobles (").'),
    ContentBlock(type: 'code', value: '# Diferentes formas de crear strings\n\ncomillas_simples = \'Hola\'\ncomillas_dobles = "Mundo"\nmultilinea = """Texto\nque ocupa\nvarias líneas"""\n\nprint(comillas_simples, comillas_dobles)\nprint(multilinea)'),
    ContentBlock(type: 'text', value: 'Puedes combinar strings usando operadores. La concatenación (+) une strings, y la repetición (*) los repite:'),
    ContentBlock(type: 'code', value: '# Operaciones con strings\nsaludo = "Hola" + " " + "Mundo"\nprint(saludo)  # Hola Mundo\n\n eco = "¡Eco! " * 3\nprint(eco)  # ¡Eco! ¡Eco! ¡Eco!\n\n# Los strings también soportan indexación\n texto = "Python"\nprint(texto[0])  # P\nprint(texto[-1]) # n\nprint(texto[0:3]) # Pyt'),
    ContentBlock(type: 'text', value: 'Los f-strings (Python 3.6+) permiten incrustar expresiones dentro de strings de forma elegante:'),
    ContentBlock(type: 'code', value: '# f-strings: la forma moderna de formatear\nnombre = "Ana"\nedad = 25\nprint(f"Me llamo {nombre} y tengo {edad} años")\n\n# También puedes incluir expresiones\nprint(f"El doble de tu edad es {edad * 2}")\n\n# Formatear números\npi = 3.14159\nprint(f"Pi con 2 decimales: {pi:.2f}")  # Pi con 2 decimales: 3.14'),
  ],
  13: [
    ContentBlock(type: 'text', value: 'Los booleanos representan valores de verdad: True (verdadero) o False (falso). Son fundamentales para la lógica y las decisiones en los programas.'),
    ContentBlock(type: 'code', value: '# Valores booleanos\nactivo = True\ncompletado = False\n\nprint(type(activo))  # <class \'bool\'>\n\n# Los booleanos se usan con operadores de comparación\nprint(10 > 5)    # True\nprint(10 == 5)   # False\nprint(10 != 5)   # True\nprint(3 <= 3)    # True'),
    ContentBlock(type: 'text', value: 'En Python, algunos valores se consideran "falsy" (equivalentes a False) y otros "truthy" (equivalentes a True):'),
    ContentBlock(type: 'code', value: '# Valores falsy y truthy\n\n# Falsy (se evalúan como False)\nprint(bool(0))          # False\nprint(bool(""))         # False\nprint(bool([]))         # False (lista vacía)\nprint(bool(None))       # False\n\n# Truthy (se evalúan como True) \nprint(bool(1))          # True\nprint(bool("Hola"))     # True\nprint(bool([1, 2, 3]))  # True'),
    ContentBlock(type: 'text', value: 'Los operadores lógicos and, or y not permiten combinar condiciones booleanas:'),
    ContentBlock(type: 'code', value: '# Operadores lógicos\nedad = 20\n\nprint(edad >= 18 and edad < 65)  # True (es adulto y no es jubilado)\nprint(edad < 13 or edad > 65)    # False (no es niño ni jubilado)\nprint(not edad >= 18)            # False (no es menor de edad)'),
  ],
  14: [
    ContentBlock(type: 'text', value: 'Las listas son colecciones ordenadas y mutables de elementos. Pueden contener cualquier tipo de dato, incluso mezclado.'),
    ContentBlock(type: 'code', value: '# Creando listas\nnumeros = [1, 2, 3, 4, 5]\nmezclada = [1, "hola", 3.14, True]\nvacia = []\n\nprint(numeros)\nprint(mezclada)\nprint(len(numeros))  # 5 (longitud de la lista)'),
    ContentBlock(type: 'text', value: 'Las listas se indexan desde 0. Puedes acceder a elementos individuales, modificarlos y usar índices negativos:'),
    ContentBlock(type: 'code', value: '# Acceso y modificación de listas\ncolores = ["rojo", "verde", "azul"]\n\nprint(colores[0])      # rojo\nprint(colores[-1])     # azul (último)\nprint(colores[0:2])    # ["rojo", "verde"] (slicing)\n\ncolores[1] = "amarillo"\nprint(colores)        # ["rojo", "amarillo", "azul"]'),
    ContentBlock(type: 'code', value: '# Métodos útiles de listas\nnumeros = [3, 1, 4, 1, 5]\n\nnumeros.append(9)     # Agrega al final: [3, 1, 4, 1, 5, 9]\nnumeros.sort()        # Ordena: [1, 1, 3, 4, 5, 9]\nnumeros.reverse()     # Invierte: [9, 5, 4, 3, 1, 1]\nprint(numeros.pop())  # Elimina y retorna el último: 1\n\nprint(numeros.count(1))  # Cuenta cuántos 1 hay: 2\nprint(len(numeros))      # Longitud: 5'),
  ],
  15: [
    ContentBlock(type: 'text', value: 'El type casting (conversión de tipos) permite convertir un valor de un tipo de dato a otro. Python proporciona funciones específicas para esto.'),
    ContentBlock(type: 'code', value: '# Conversión a entero (int)\nprint(int(3.14))      # 3 (trunca decimales)\nprint(int("42"))      # 42\nprint(int(True))      # 1\n\n# Conversión a float (float)\nprint(float(5))       # 5.0\nprint(float("3.14"))  # 3.14\n\n# Conversión a string (str)\nprint(str(42))        # "42"\nprint(str(3.14))     # "3.14"\nprint(str(True))     # "True"'),
    ContentBlock(type: 'text', value: 'Es importante saber cuándo Python puede convertir automáticamente y cuándo necesita ayuda explícita. Algunas conversiones no son posibles:'),
    ContentBlock(type: 'code', value: '# Conversiones automáticas (Python lo hace solo)\nresultado = 10 + 3.5  # 13.5 (int + float = float)\nprint(type(resultado))  # <class \'float\'>\n\n# Conversiones que requieren ayuda\nedad = "25"\n# print(edad + 5)  # Error: no puedes sumar string + int\nprint(int(edad) + 5)  # 30 (conversión explícita)\n\n# Conversiones no válidas\n# int("hola")   # ValueError: invalid literal\n# float("3.14x")  # ValueError'),
    ContentBlock(type: 'code', value: '# Ejemplo práctico: calculadora de propina\ncosto_str = "45.50"\ncosto = float(costo_str)\npropina = costo * 0.15\n\nprint(f"Costo: \${costo:.2f}")\nprint(f"Propina (15%): \${propina:.2f}")\nprint(f"Total: \${costo + propina:.2f}")'),
  ],

  // ===== MÓDULO 4: Operadores =====
  16: [
    ContentBlock(type: 'text', value: 'Los operadores aritméticos te permiten realizar operaciones matemáticas básicas. Python soporta todos los operadores que esperarías de una calculadora.'),
    ContentBlock(type: 'code', value: '# Operadores aritméticos básicos\na = 15\nb = 4\n\nprint(f"Suma: {a + b}")            # 19\nprint(f"Resta: {a - b}")           # 11\nprint(f"Multiplicación: {a * b}")  # 60\nprint(f"División: {a / b}")        # 3.75\nprint(f"División entera: {a // b}")  # 3\nprint(f"Módulo: {a % b}")          # 3\nprint(f"Potencia: {a ** b}")       # 50625'),
    ContentBlock(type: 'text', value: 'La división siempre retorna un float, incluso si es exacta. La división entera (//) trunca el resultado. El operador módulo (%) retorna el resto de la división.'),
    ContentBlock(type: 'code', value: '# Diferencia entre división y división entera\nprint(10 / 3)    # 3.3333333333333335\nprint(10 // 3)   # 3\nprint(-10 // 3)  # -4 (redondea hacia abajo)\n\n# Útil: saber si un número es par o impar\nnumero = 7\nif numero % 2 == 0:\n    print(f"{numero} es par")\nelse:\n    print(f"{numero} es impar")'),
    ContentBlock(type: 'code', value: '# Jerarquía de operaciones\n# 1. Paréntesis ()\n# 2. Exponente **\n# 3. Multiplicación, división, módulo (*, /, //, %)\n# 4. Suma y resta (+, -)\n\nresultado = 2 + 3 * 4\nprint(resultado)  # 14 (no 20)\n\nresultado2 = (2 + 3) * 4\nprint(resultado2)  # 20 (paréntesis primero)'),
  ],
  17: [
    ContentBlock(type: 'text', value: 'Los operadores de comparación comparan dos valores y retornan un booleano (True o False). Son esenciales para tomar decisiones en el código.'),
    ContentBlock(type: 'code', value: '# Operadores de comparación\nprint(10 == 10)   # True  (igual a)\nprint(10 != 5)    # True  (diferente de)\nprint(10 > 5)     # True  (mayor que)\nprint(10 < 5)     # False (menor que)\nprint(10 >= 10)   # True  (mayor o igual que)\nprint(10 <= 5)    # False (menor o igual que)'),
    ContentBlock(type: 'text', value: 'Los operadores == y != comparan el valor, mientras que is e is not comparan la identidad (si son el mismo objeto en memoria):'),
    ContentBlock(type: 'code', value: '# == vs is\na = [1, 2, 3]\nb = [1, 2, 3]\nc = a\n\nprint(a == b)  # True (mismo valor)\nprint(a is b)  # False (objetos diferentes)\nprint(a is c)  # True (misma referencia)'),
    ContentBlock(type: 'code', value: '# Comparación de strings\nprint("Python" == "Python")    # True\nprint("Python" == "python")    # False (sensible a mayúsculas)\nprint("a" < "b")              # True (orden alfabético)\nprint("Hola" != "Adiós")      # True'),
  ],
  18: [
    ContentBlock(type: 'text', value: 'Los operadores lógicos permiten combinar múltiples condiciones. Son and (y), or (o) y not (no).'),
    ContentBlock(type: 'code', value: '# Operador AND (todas las condiciones deben ser True)\nedad = 25\ntiene_licencia = True\n\nif edad >= 18 and tiene_licencia:\n    print("Puedes conducir")\n\n# Operador OR (al menos una condición debe ser True)\nes_fin_semana = False\nes_vacaciones = True\n\nif es_fin_semana or es_vacaciones:\n    print("Puedes descansar")'),
    ContentBlock(type: 'code', value: '# Operador NOT (invierte el valor booleano)\nestá_lloviendo = False\n\nif not está_lloviendo:\n    print("Puedes salir sin paraguas")\n\n# Cortocircuito (short-circuit evaluation)\ndef obtener_dato():\n    print("Obteniendo dato...")\n    return True\n\n# Si la primera condición es False, no evalúa la segunda\nresultado = False and obtener_dato()  # No imprime nada\nresultado = True or obtener_dato()   # No imprime nada'),
    ContentBlock(type: 'code', value: '# Ejemplo combinado\nusuario = "admin"\ncontraseña = "1234"\nintentos = 2\n\npuede_acceder = (usuario == "admin" and contraseña == "1234") or intentos < 3\nprint(f"¿Puede acceder? {puede_acceder}")  # True'),
  ],
  19: [
    ContentBlock(type: 'text', value: 'Los operadores de asignación combinada permiten modificar una variable aplicando una operación al mismo tiempo. Son una forma abreviada de escribir operaciones comunes.'),
    ContentBlock(type: 'code', value: '# Operadores de asignación combinada\nx = 10\n\nx += 3    # x = x + 3  → 13\nx -= 5    # x = x - 5  → 8\nx *= 2    # x = x * 2  → 16\nx /= 4    # x = x / 4  → 4.0\nx //= 2   # x = x // 2 → 2.0\nx %= 3    # x = x % 3  → 2.0\nx **= 3   # x = x ** 3 → 8.0\n\nprint(x)  # 8.0'),
    ContentBlock(type: 'text', value: 'Son especialmente útiles en bucles y contadores:'),
    ContentBlock(type: 'code', value: '# Uso práctico en contadores\ntotal = 0\nfor i in range(1, 6):\n    total += i  # Equivale a: total = total + i\n    print(f"Sumando {i}, total parcial: {total}")\n\nprint(f"Suma total: {total}")  # 15'),
  ],
  20: [
    ContentBlock(type: 'text', value: 'La precedencia de operadores determina el orden en que se evalúan las operaciones. Python sigue las reglas matemáticas estándar (PEMDAS: Paréntesis, Exponentes, Multiplicación, División, Adición, Sustracción).'),
    ContentBlock(type: 'code', value: '# Precedencia en Python (de mayor a menor)\n# 1. () paréntesis\n# 2. ** exponente\n# 3. +x, -x signo unario\n# 4. *, /, //, % multiplicación y división\n# 5. +, - suma y resta\n# 6. ==, !=, >, <, >=, <= comparación\n# 7. not operador lógico\n# 8. and operador lógico\n# 9. or operador lógico\n\n# Ejemplos\nprint(2 + 3 * 4)       # 14\nprint((2 + 3) * 4)     # 20\nprint(2 ** 3 + 4)      # 12\nprint(2 ** (3 + 4))    # 128'),
    ContentBlock(type: 'code', value: '# Siempre usa paréntesis para mayor claridad\n\n# Confuso:\nresultado = a + b * c / d - e ** f\n\n# Claro:\nresultado = a + ((b * c) / d) - (e ** f)'),
  ],

  // ===== MÓDULO 5: Condicionales =====
  21: [
    ContentBlock(type: 'text', value: 'Las estructuras condicionales permiten ejecutar diferentes bloques de código según se cumplan o no ciertas condiciones. La más básica es if.'),
    ContentBlock(type: 'code', value: '# Estructura básica de if\nedad = 18\n\nif edad >= 18:\n    print("Eres mayor de edad")\n    print("Puedes votar")\n\nprint("Esta línea siempre se ejecuta")'),
    ContentBlock(type: 'text', value: 'Recuerda que en Python los bloques se definen por indentación. Todos los líneas con la misma indentación después del if pertenecen al bloque.'),
    ContentBlock(type: 'code', value: '# La indentación es obligatoria en Python\nnota = 85\n\nif nota >= 70:\n    print("¡Aprobaste!")       # Dentro del if\n    print("Sigue así")         # Dentro del if\nprint("Fin de la evaluación")  # Fuera del if'),
  ],
  22: [
    ContentBlock(type: 'text', value: 'La estructura if-else permite ejecutar un bloque cuando la condición es True y otro diferente cuando es False.'),
    ContentBlock(type: 'code', value: '# If-else\nedad = 16\n\nif edad >= 18:\n    print("Eres mayor de edad")\nelse:\n    print("Eres menor de edad")'),
    ContentBlock(type: 'code', value: '# Ejemplo práctico: número par o impar\nnumero = 7\n\nif numero % 2 == 0:\n    print(f"{numero} es par")\nelse:\n    print(f"{numero} es impar")'),
    ContentBlock(type: 'text', value: 'El else es opcional. Puedes tener un if sin else si solo necesitas ejecutar código cuando la condición se cumple.'),
  ],
  23: [
    ContentBlock(type: 'text', value: 'Cuando tienes múltiples condiciones que evaluar, usas elif (else if). Te permite encadenar varias condiciones de forma limpia.'),
    ContentBlock(type: 'code', value: '# If-elif-else\nnota = 85\n\nif nota >= 90:\n    print("Excelente")\nelif nota >= 80:\n    print("Muy bien")\nelif nota >= 70:\n    print("Bien")\nelif nota >= 60:\n    print("Suficiente")\nelse:\n    print("Reprobado")'),
    ContentBlock(type: 'text', value: 'Python evalúa las condiciones de arriba a abajo. En cuanto encuentra una condición True, ejecuta su bloque y salta el resto.'),
    ContentBlock(type: 'code', value: '# Ejemplo: clasificador de edades\nedad = 25\n\nif edad < 13:\n    print("Niño")\nelif edad < 18:\n    print("Adolescente")\nelif edad < 65:\n    print("Adulto")\nelse:\n    print("Adulto mayor")'),
  ],
  24: [
    ContentBlock(type: 'text', value: 'Puedes colocar condicionales dentro de otros condicionales. Esto se llama anidamiento y permite evaluar condiciones más complejas.'),
    ContentBlock(type: 'code', value: '# Condicionales anidados\nusuario = "admin"\ncontraseña_correcta = True\n\nif usuario == "admin":\n    if contraseña_correcta:\n        print("Acceso concedido")\n    else:\n        print("Contraseña incorrecta")\nelse:\n    print("Usuario no encontrado")'),
    ContentBlock(type: 'text', value: 'Aunque los condicionales anidados son funcionales, es mejor evitarlos cuando sea posible usando operadores lógicos:'),
    ContentBlock(type: 'code', value: '# En lugar de anidar, usa and\n# Mejor:\nif usuario == "admin" and contraseña_correcta:\n    print("Acceso concedido")\nelif usuario == "admin":\n    print("Contraseña incorrecta")\nelse:\n    print("Usuario no encontrado")'),
  ],
  25: [
    ContentBlock(type: 'text', value: 'El operador ternario (o condicional en línea) permite escribir if-else en una sola línea. Es útil para asignaciones condicionales simples.'),
    ContentBlock(type: 'code', value: '# Operador ternario\n# Sintaxis: valor_si_true if condición else valor_si_false\n\nedad = 20\nmensaje = "Mayor de edad" if edad >= 18 else "Menor de edad"\nprint(mensaje)  # Mayor de edad\n\n# Equivalente a:\nif edad >= 18:\n    mensaje = "Mayor de edad"\nelse:\n    mensaje = "Menor de edad"'),
    ContentBlock(type: 'code', value: '# Ejemplos prácticos\n\n# Determinar si un número es par o impar\nnumero = 7\ntipo = "par" if numero % 2 == 0 else "impar"\nprint(f"{numero} es {tipo}")\n\n# Valor absoluto sin usar abs()\nvalor = -10\nabsoluto = valor if valor >= 0 else -valor\nprint(absoluto)  # 10\n\n# Máximo entre dos números\na, b = 15, 20\nmaximo = a if a > b else b\nprint(maximo)  # 20'),
  ],

  // ===== MÓDULO 6: Bucles =====
  26: [
    ContentBlock(type: 'text', value: 'El bucle while ejecuta un bloque de código mientras una condición sea True. Es útil cuando no sabes de antemano cuántas veces necesitas repetir.'),
    ContentBlock(type: 'code', value: '# Bucle while básico\ncontador = 1\n\nwhile contador <= 5:\n    print(f"Vuelta número {contador}")\n    contador += 1\n\nprint("Bucle terminado")'),
    ContentBlock(type: 'warning', value: '¡Cuidado con los bucles infinitos! Si la condición nunca se vuelve False, el bucle se ejecutará para siempre y congelará tu programa. Siempre asegúrate de que la variable de condición cambie dentro del bucle.'),
    ContentBlock(type: 'code', value: '# Bucle infinito (NO EJECUTAR)\n# while True:\n#     print("Esto nunca termina")\n\n# Forma correcta: asegurar que la condición cambie\nintentos = 0\nwhile intentos < 3:\n    print(f"Intento {intentos + 1}")\n    intentos += 1  # ← Esto evita el bucle infinito'),
  ],
  27: [
    ContentBlock(type: 'text', value: 'El bucle for en Python se usa para iterar sobre secuencias (listas, strings, rangos, etc.). Es más seguro que while porque no puede crear bucles infinitos fácilmente.'),
    ContentBlock(type: 'code', value: '# For loop básico\nfrutas = ["manzana", "banana", "cereza"]\n\nfor fruta in frutas:\n    print(f"Me gusta la {fruta}")\n\nprint("Fin del bucle")'),
    ContentBlock(type: 'code', value: '# Iterando sobre un string\npalabra = "Python"\n\nfor letra in palabra:\n    print(f"Letra: {letra}")\n\n# Iterando sobre un rango\nfor i in range(5):\n    print(f"Número: {i}")  # 0, 1, 2, 3, 4'),
    ContentBlock(type: 'text', value: 'El bucle for automaticamente toma cada elemento de la secuencia y lo asigna a la variable del bucle. No necesitas manejar índices ni condiciones de terminación.'),
  ],
  28: [
    ContentBlock(type: 'text', value: 'La función range() genera secuencias de números. Es muy usada con for loops para repetir acciones un número específico de veces.'),
    ContentBlock(type: 'code', value: '# range(stop) - 0 a stop-1\nfor i in range(5):\n    print(i, end=" ")  # 0 1 2 3 4\n\nprint()\n\n# range(start, stop)\nfor i in range(2, 7):\n    print(i, end=" ")  # 2 3 4 5 6\n\nprint()\n\n# range(start, stop, step)\nfor i in range(0, 10, 2):\n    print(i, end=" ")  # 0 2 4 6 8'),
    ContentBlock(type: 'code', value: '# Usos prácticos de range\n\n# Sumar números del 1 al 100\nsuma = 0\nfor i in range(1, 101):\n    suma += i\nprint(f"Suma del 1 al 100: {suma}")\n\n# Tabla de multiplicar\ntabla = 5\nfor i in range(1, 11):\n    print(f"{tabla} × {i} = {tabla * i}")'),
    ContentBlock(type: 'code', value: '# range con paso negativo\nfor i in range(10, 0, -1):\n    print(i, end=" ")  # 10 9 8 7 6 5 4 3 2 1\n\nprint("\\n¡Despegue!")'),
  ],
  29: [
    ContentBlock(type: 'text', value: 'Las declaraciones break y continue permiten controlar el flujo de los bucles. break termina el bucle por completo, mientras que continue salta a la siguiente iteración.'),
    ContentBlock(type: 'code', value: '# Break: termina el bucle\nfor i in range(1, 11):\n    if i == 5:\n        print("¡Encontramos el 5! Terminando...")\n        break\n    print(i)  # 1 2 3 4\n\nprint("Bucle terminado")'),
    ContentBlock(type: 'code', value: '# Continue: salta a la siguiente iteración\nfor i in range(1, 8):\n    if i % 2 == 0:\n        continue  # Salta los números pares\n    print(i, end=" ")  # 1 3 5 7'),
    ContentBlock(type: 'code', value: '# Ejemplo práctico: validar entrada\nwhile True:\n    respuesta = input("¿Cuánto es 5 + 3? ")\n    if respuesta == "8":\n        print("¡Correcto!")\n        break\n    else:\n        print("Incorrecto. Intenta de nuevo.\\n")'),
  ],
  30: [
    ContentBlock(type: 'text', value: 'Los bucles anidados son bucles dentro de otros bucles. Por cada iteración del bucle externo, el bucle interno se ejecuta completamente.'),
    ContentBlock(type: 'code', value: '# Bucles anidados: tabla de multiplicar del 1 al 3\nfor i in range(1, 4):\n    print(f"\\nTabla del {i}:")\n    for j in range(1, 11):\n        print(f"  {i} × {j} = {i * j}")'),
    ContentBlock(type: 'code', value: '# Dibujando un rectángulo con asteriscos\nfilas = 5\ncolumnas = 10\n\nfor i in range(filas):\n    for j in range(columnas):\n        print("*", end="")\n    print()  # Nueva línea'),
    ContentBlock(type: 'code', value: '# Triángulo con asteriscos\nfor i in range(1, 6):\n    for j in range(i):\n        print("*", end="")\n    print()\n\n# Salida:\n# *\n# **\n# ***\n# ****\n# *****'),
    ContentBlock(type: 'text', value: 'Los bucles anidados son útiles para trabajar con matrices, tablas, y patrones. La complejidad aumenta porque si el bucle externo se ejecuta N veces y el interno M veces, el total de operaciones es N × M.'),
  ],
};
