(* A Simple todo-list using local storage *)

open Bootstrapper

type task = {
  title : string
; label : string
; state : bool
} deriving (Yojson)

let task title label state = {
  title = title
; label = label
; state = state
}

let task_tojson = Yojson.to_string<task>
let task_ofjson = Yojson.from_string<task>



module Gui =
struct
  
  let title container =
    let t = Html.element ~into:(Some container) Dom_html.createH1 in
    let _ = Html.text ~into:(Some t) "Liste des tâches à réaliser" in
    t

  let create_list container =
    Html.element ~into:(Some container) Dom_html.createUl

  let create_form container =
    let title = Html.input_create ~into:(Some container) "text" "title" in
    let label = Html.input_create ~into:(Some container) "text" "Label" in
    let press = Html.input_create ~into:(Some container) "button" "record" in
    (title, label, press)
    
end

let task_id () =
  (jsnew Js.date_now ()) ## getTime()
  |> string_of_float
  

let record_task t l =
  let title    = Html.input_value t in
  let label    = Html.input_value l in
  let jsontask = task_tojson (task title label false) in
  let _        = Storage.Local.set (task_id ()) jsontask
  in ()

let rewrite_ul ul =
  let childs = ul 
    
let bind_event e t l u  =
  Event.(
    e >- (
      click, fun _ _ ->
        let _ = record_task t l in
        rewrite_ul u
    )
  )
                  
module Todolist =
  Application (
  struct
    
    let initialize () =
      let app   = Html.get_by_id "app" in
      let _     = Gui.title app in
      let (task_title, task_label, task_press) = Gui.create_form app in
      let list  = Gui.create_list app in
      let _ = bind_event task_press task_title task_label list in
      ()
        
  end
  )
