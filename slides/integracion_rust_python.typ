// Get Polylux from the official package repository
#import "@preview/polylux:0.4.0": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#show: codly-init.with()
#codly(zebra-fill: none)

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 20pt, font: "Lato")

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

  July 23, 2023
]

#slide[
  == ¿Qué es PyO3?

  PyO3 es un proyecto desarrollado en Rust que permite la integración con Python. 
]

#slide[
  == La filosofía de PyO3 en el ecosistema de Python

  PyO3 agrega el poder y precisión de Rust al ecosistema de Python. No es una sustitución. Es complementario.
]

#slide[
  == Cómo funciona PyO3 

  PyO3 user place procedural macro ("proc macro") attributes on their Rust code.

  These generate Rust code calling Python's C API to define Python functions, classes and modules.

  ```rust
  #[pyfunction]
  fn my_rust_function(){...}
  ```

]

#slide[
  == Cómo funciona PyO3 

  PyO3 user place procedural macro ("proc macro") attributes on their Rust code.

  These generate Rust code calling Python's C API to define Python functions, classes and modules.

  #toolbox.side-by-side(gutter: 3mm, columns: (2fr, 2fr), 

  [
  ```rust
  #[pyfunction]
  fn my_rust_function(){...}
  ```

  Tools like maturin and setuptools-rust handle the task of compiling the Rust code to a library placed where Python can consume it.
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
  == ¿Cómo consume Python las extensiones?

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
  PyO3 translation of this function is very mechanical :

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
        for word in line.split(){
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
  PyO3 translation of this function is very mechanical:


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
        for word in line.split(){
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
  == What does the interpreter do when we call this function?

    ```python 
    import hello_pyo3

    contents = "a b c d"

    hello_pyo3.count_ocurrences(contents, needle = "a")
    ```

]