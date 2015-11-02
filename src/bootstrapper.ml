(*  * Small bootstrapper for Js_of_ocaml Projects
 * ~ provide a simple library for common uses   *)


module Pervasives = Pervasives 
module Option     = BootOption
module Promise    = BootPromise
module Event      = BootEvent
module Interval   = BootInterval
module Html       = BootHtml
module Ajax       = BootAjax
module Color      = BootColor
module Canvas     = BootCanvas
module Storage    = BootStorage
module Functor    = BootFunctor
  
include Pervasives
include Functor
