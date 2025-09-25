// Get Polylux from the official package repository
#import "@preview/polylux:0.4.0": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#show: codly-init.with()
#codly(zebra-fill: none)

// Make the paper dimensions fit for a presentation and the text larger
#let ukj-blue = rgb(0, 84, 163)

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 20pt, font: "Lato")

#show <a>: set text(blue)

#show raw: it => {
  show regex("pin\d"): it => pin(eval(it.text.slice(3)))
  it
}


#codly(
  languages: (
    rust: (name: "Rust", icon: "🦀", color: rgb("#CE412B")),
    python : (name : "Python", icon : "🐍")
  )
)

// Use #slide to create a slide and style it using your favourite Typst functions
#slide[
  #set align(horizon)
  = Integración de Rust y Python con PyO3

  Hermilo

  4 de Septiembre 2025
]

#slide[
  == Introducción
  //== ¿Qué es Refactorizar?
  - Nos gustaría mejorar el desempeño y diseño del software disponible.
  - Tendencias tecnológicas y lenguajes de programación novedosos hace tentador a las empresas #text(fill: ukj-blue)[*reescribir*] sus productos.
  -  Si algunas empresas han mostrado los beneficios en desempeño, seguridad y mantenibilidad de #text(fill: ukj-blue)[*reescribir*] su software en un lenguaje nuevo, ¿Por qué no hacer lo mismo? 
  - #text(fill: red)[*Reescribir software desde cero es una tarea difícil y riesgosa*].
  - #text(fill: ukj-blue)[*El software existente puede tener años de experiencia en producción y monitoreo, así como una base de conocimiento para identificar bugs.*]
]

#slide[
  == ¿Qué es Refactorizar?
  - #text(fill: red)[*Refactorizar*] es #text(fill: ukj-blue)[*"reescritura en una menor escala"*] #cite(<refactoringRust2025mara>). 
  - Es una técnica más controlada para mejorar el diseño y performance del software existente. 
  - En lugar de reemplazar al sistema actual por completo, nos gustaría detectar #text(fill: ukj-blue)[*las partes más criticas de nuestro código*] que necesitan ser refactorizadas.
  //- Al refactorizar se busca hacer cambios pequeños e independientes que puedan ser desplegados lo antes posible. 
  //- Se agregan métricas y monitoreo en torno a estos cambios para garantizar que cuando se implementen, los resultados se mantengan consistentes.

]


#[
  #set page(margin: (top: 0.3cm, left: 1cm))
#slide[
  == ¿Qué es Refactorizar?
        #figure(
      image("images/remodelacion.png", width: 88%),
    ) 
]
]



#slide[
  == Python's bottleneck is inevitably performance (Hewitt, 2024)
  - Muchas bibliotecas de Python tiene performance porque están parcial o totalmente implementadas en lenguajes de bajo nivel como C, C++, Fortran, Cython o bien con implementaciones alternativas de Python como PyPy, IronPython, Jython, etc #cite(<fastPython2023rodrigues>).
  - #text(fill: ukj-blue)[*Si existen alternativas para mejorar el desempeño, ¿Por qué una alternativa adicional?*] #text(fill: red)[*¿Por qué Rust?*]
]

#slide[
  == ¿Por qué Rust?

  #text(font: "Lato", size : 17pt)[
  - Rust es un lenguaje de programación que enfatiza tiempo de ejecución rápido, alta confiabilidad, memory safety y fearless concurrency.

    - *Confiabilidad* : Control de errores. Patrón que combina ```rust Result<T, E>``` Type con Pattern Matching donde el desarrollador se encarga de manejar los errores como parte del desarrollo del programa. 
    - *Memory Safety* : Sin la existencia de un recolector de basura. Concepto de  #text(fill: ukj-blue)[*borrow checker*] que verifica que los accesos a datos son legales, lo que le permite a Rust prevenir problemas de seguridad sin imponer costos durante el tiempo de ejecución #cite(<rustAction2023mcnamara>). Tres conceptos importantes : 
      - *lifetimes*
      - *ownership*
      - *borrowing*
    - *Concurrency* : Al escribir código multithreaded, la desarrolladora tendrá la confianza que no producirá #text(fill: ukj-blue)[*data races*].

  ]
]

#[
  #set page(margin: (top: 0.3cm, left: 1cm))
#slide[
  
  == ¿Por qué Rust?

  #text(font: "Lato", size : 30pt)[
    #text(fill: ukj-blue)[*Rust offers power and precision to go beyond Python's limits (Hewitt, 2024)*]
      #figure(
      image("images/hewitt.jpeg", width: 65%),
    ) 
  ]

]
]

#slide[
  == ¿Qué es PyO3?

  PyO3 es un proyecto desarrollado en Rust que permite la integración con Python. 

  #text(font: "Lato", size : 18pt)[
  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 


    [
      #figure(
      image("images/integracion_rust_python-pyo3_intro.png", width: 80%),
      caption: [Tomado de Hewitt 2025],
    ) 

    - Guía para el desarrollador : #link("https://pyo3.rs")<a>
    - Documentación : #link("https://docs.rs/pyo3")<a>
    - Github : #link("https://github.com/pyo3/pyo3")<a>
    ], 
    [
      == Proyectos de soporte
      - *maturin* : CLI build backend.
      - *setuptools-rust* : adiciona Rust a proyectos de setuptools.
      - *rust-numpy* : numpy interoperability.  

    ]

  )
  ]

]

#slide[
  == La filosofía de PyO3 en el ecosistema de Python

  PyO3 agrega el poder y precisión de Rust al ecosistema de Python. No es una sustitución. Es complementario.

      #figure(
      image("images/integracion_rust_python-pyo3_vision.png", width: 40%),
      caption: [Tomado de Hewitt 2025],
    ) 
]

#slide[
  == Cómo funciona PyO3 
  PyO3 usa macros procedurales ("proc macro") las cuales son una forma de metaprogramación#footnote[*Metaprogramación* es código que usará otro código como insumo] que permite manipular, generar código adicional, o agregar nuevas capacidades a nuestro programa#footnote[En Rust existen dos tipos de macros : *declarativas* y *procedurales*].


  La macro expande el código de Rust para llamar la API de C de Python para definir funciones, clases y módulos.

  ```rust
  #[pyfunction]
  fn my_rust_function(){...}
  ```

]

#slide[
  == Cómo funciona PyO3 

  PyO3 usa macros procedurales ("proc macro") las cuales son una forma de metaprogramación#footnote[*Metaprogramación* es código que usará otro código como insumo] que permite manipular, generar código adicional, o agregar nuevas capacidades a nuestro programa#footnote[En Rust existen dos tipos de macros : *declarativas* y *procedurales*].


  La macro expande el código de Rust para llamar la API de C de Python para definir funciones, clases y módulos.

  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [
  ```rust
  #[pyfunction]
  fn my_rust_function(){...}
  ```

  ], 
  [
    #text(font: "Lato", size : 15pt)[
      ```rust
      unsafe extern "C" fn __wrap(){...}
      PyMethodDef{
          ml_meth: __wrap as *mut c_void,
          ...
      }
      ```
  ]
  ]

  )

]


#slide[
  == Cómo funciona PyO3 
  #text(font: "Lato", size : 17pt)[
  PyO3 usa macros procedurales ("proc macro") las cuales son una forma de metaprogramación que permite manipular, generar código adicional, o agregar nuevas capacidades a nuestro programa.


  La macro expande el código de Rust para llamar la API de C de Python para definir funciones, clases y módulos.
  ]

  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [
  ```rust
  #[pyfunction]
  fn my_rust_function(){...}
  ```
  #text(font: "Lato", size : 17pt)[

  Herramientas como maturin y setuptools-rust se encargan de la tarea de compilar el código de Rust a un módulo para que Python pueda consumirlo.

  ]
  ], 
  [
    #text(font: "Lato", size : 14pt)[
      ```rust
      unsafe extern "C" fn __wrap(){...}
      PyMethodDef{
          ml_meth: __wrap as *mut c_void,
          ...
      }
      ```
  ]
      #figure(
      image("images/integracion_rust_python-pyo3_abi.png", width: 40%),
    ) 
  ]

  )

]

#slide[
  == ¿Cómo consume Python las extensiones?
  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [
  - Comunmente la declaración ```import``` de Python se usa para cargar un archivo (módulo) de Python.
  ], 
  [
    #text(font: "Lato", size : 25pt)[
      ```python
      import b
      ```
      #figure(
      image("images/integracion_rust_python-python_rust_consumption_uno.png", width: 20%),
    ) 
  ]

  ]

  )
]

#slide[
  == ¿Cómo consume Python las extensiones?
  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [
  - Comunmente la declaración ```import``` de Python se usa para cargar un archivo (módulo) de Python.
  - También puede carga un *extension module* de una biblioteca compatible con el ABI#footnote[*Application Binary Interface*] de Python.
  - Esto es apliamente usado, e.g. Cython, C, C++, y Rust.
  ], 
  [
    #text(font: "Lato", size : 25pt)[
      ```python
      import b
      ```
      #figure(
      image("images/integracion_rust_python-python_rust_consumption_dos.png", width: 66%),
    ) 
  

  ]
  ]
  )
]


#[
#set page(margin: (top: 0.4cm, left: 1cm))
#slide[
  == Cython Compiler

  #toolbox.side-by-side(gutter: 3mm, columns: (1fr, 2fr),
  [
    - El compilador Cython convierte el código fuente de Cython a código de C optimizado.
    - Posteriormente se compilará durante el proceso de construcción del paquete.
  ], 

  figure(
      image("images/cpython_compilacion.png", width: 95%),
      caption: [Tomado de #cite(<publishingPython2022hillard>)]
  )
  )
]
]

#[
#set page(margin: (top: 0.4cm, left: 1cm))
#slide[
  == Portabilidad
  - Cuando escribimos paquetes usando solo Python, este es #text(fill: ukj-blue)[*extremadamente portable*]-cualquier sistema que tenga una versión compatible de Python puede ejecutar el paquete.
  - Cuando incluimos código que debe ser compilado, #text(fill: ukj-blue)[*el código fuente tipicamente debe ser compilado separadamente para cada arquitectura y SO donde será usado*].

  #figure(
      image("images/anatomy_wheel.png", width: 68%),
      caption: [Anatomía de un archivo de distribución wheel. Tomado de #cite(<publishingPython2022hillard>)]
  )
]
]

#slide[
  == Ejemplo
  Programa que cuenta ocurrencias en un texto:

  #text(font: "Lato", size : 16pt)[
  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 


  [
  ```python 
  def count_ocurrences(
      contents: str,
      needle: str,
      ) -> int:

      total = 0

      for line in contents.splitlines():
          for word in line.split():
              if word == needle:
                  total+=1

      return total
  ```
  ], 
  [

  ]

  )
  ]
]


#slide[
  == Ejemplo
  La traducción de esta función con PyO3 es mecánica:

  #text(font: "Lato", size : 14pt)[
  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 


  [
  ```python 
  def count_ocurrences(
      contents: str,
      needle: str,
      ) -> int:

      total = 0

      for line in contents.splitlines():
          for word in line.split():
              if word == needle:
                  total+=1

      return total
  ```
  ], 
  [
  ```rust
  #[pyfunction]
  fn count_ocurrences(
      contents: &str, 
      needle: &str,
  ) -> usize {
    let mut total = 0;
    for line in contents.lines(){
        for word in line.split(" "){
            if word == needle{
                total += 1;
            }
        }
    } 
    total
  }
  ```
  ]

  )
  ]
]


#slide[
  == Ejemplo
  La traducción de esta función con PyO3 es mecánica:


  #text(font: "Lato", size : 14pt)[
  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 


  [
  ```python 
  def count_ocurrences(
      contents: str,
      needle: str,
      ) -> int:

      total = 0

      for line in contents.splitlines():
          for word in line.split():
              if word == needle:
                  total+=1

      return total
  ```
  ], 
  [

  ```rust
  #[pyfunction]
  fn count_ocurrences(
      contents: &str, 
      needle: &str,
  ) -> usize {
    let mut total = 0;
    for line in contents.lines(){
        for word in line.split(" "){
            if word == needle{
                total += 1;
            }
        }
    } 
    total
  }
  ```

  ]

  )
  ]

#place(dy: -50pt, dx : 460pt)[
  #box(height: 20pt, fill: yellow)[*\~ 2-4X faster (Python 3.12)*]
]

]


#slide[
    #text(font: "Lato", size : 12pt)[
  #toolbox.side-by-side(gutter: 3mm, columns: (2.5fr, 2fr), 


  [
  ```rust
  /// A Python module implemented in Rust
  #[pyo3::pymodule]
  mod hello_pyo3{
      use pyo3::prelude::*;
      /// Counts the number of occurrences of `needle` in `contents`.
      #[pyfunction]
      fn count_ocurrences(contents: &str, needle: &str) -> usize:
          let mut total = 0;  
          for line in contents.lines(){
              for word in line.split(" "){
                  if word == needle{
                      total += 1;
                  }
              }
          }
          total

  }
  ```

  #text(font: "Lato", size : 25pt)[*Rust Source*]
  ], 
  [


  ]

  )
  ]
]


#slide[
    #text(font: "Lato", size : 12pt)[
  #toolbox.side-by-side(gutter: 3mm, columns: (2.5fr, 2fr), 


  [
  ```rust
  /// A Python module implemented in Rust
  #[pyo3::pymodule]
  mod hello_pyo3{
      use pyo3::prelude::*;
      /// Counts the number of occurrences of `needle` in `contents`.
      #[pyfunction]
      fn count_ocurrences(contents: &str, needle: &str) -> usize:
          let mut total = 0;  
          for line in contents.lines(){
              for word in line.split(" "){
                  if word == needle{
                      total += 1;
                  }
              }
          }
          total

  }
  ```
  #text(font: "Lato", size : 25pt)[*Rust Source*]
  ], 
  [

    ```python 
    import hello_pyo3

    contents = "a b c d"

    hello_pyo3.count_ocurrences(contents, needle = "a")
    ```

    #text(font: "Lato", size : 25pt)[*Python API*]
  ]

  )
  ]
]

#slide[
  == ¿Qué hace el intérprete cuando llamamos a esta función?

    ```python 
    import hello_pyo3

    contents = "a b c d"

    hello_pyo3.count_ocurrences(contents, needle = "a")
    ```

]

#slide[
  == ¿Qué hace el intérprete cuando llamamos a esta función?

#text(font: "Lato", size : 18pt)[
```python 
import dis

dis.dis('count_ocurrences("a b c d e", needle="a")')
  0           0 RESUME                   0

  1           2 PUSH_NULL
              4 LOAD_NAME                0 (count_ocurrences)
              6 LOAD_CONST               0 ('a b c d e')
              8 LOAD_CONST               1 ('a')
             10 KW_NAMES                 2 (('needle',))
             12 CALL                     2
             20 RETURN_VALUE
    ```
]
]

#slide[
  #bibliography("references.bib",  style: "apa")
]
