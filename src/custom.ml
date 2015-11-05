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

let change_state t s = { t with state = s }

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

  let task_class task =
    let f = if task.state then "finished" else "not-finished" in
    ["a_task"; f]

  let swap_btn task btn =
    if task.state then
      btn ## value <- (Js.string "Reprendre")
    else btn ## value <- (Js.string "Terminer")

  let create_block_task ul id js_task =
    let task = task_ofjson js_task in
    let li = Html.element
        ~id:(Some id)
        ~classes:(task_class task)
        Dom_html.createLi
    in
    let title = Html.element
        ~classes:["a_title"]
        ~into:(Some li)
        Dom_html.createSpan
    in 
    let label = Html.element
        ~classes:["a_label"]
        ~into:(Some li)
        Dom_html.createSpan
    in
    let end_task = Html.input_create ~into:(Some li) "button" "Terminer" in
    let _ = swap_btn task end_task in
    let raz_task = Html.input_create ~into:(Some li) "button" "Supprimer" in
    let _ =
      Event.(
        end_task >- (
          click, fun _ _ ->
            match Storage.Local.get id with
            | None -> ()
            | Some thing ->
              let rtask = task_ofjson thing in
              let new_task = (change_state task (not rtask.state)) in 
              let _ =
                Storage.Local.set
                  id (new_task |> task_tojson)
              in
              let _ = Html.remove_classes li ["finished"; "not-finished"] in
              let _ = Html.add_classes li (task_class new_task) in
              swap_btn new_task end_task
        )
      )
    in 
    let _ =
      Event.(
        raz_task >- (
          click, fun _ _ ->
            let _ = Storage.Local.remove id in
            Dom.removeChild ul li
        )
      )
    in 
    let _ = Html.text ~into:(Some title) task.title in
    let _ = Html.text ~into:(Some label) task.label in
    Html.(ul <+> li)
         
    
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
  let _ = Html.remove_children ul in
  let hash = Storage.Local.to_hashtbl () in
  Hashtbl.iter (fun key value ->
      Gui.create_block_task ul key value
    ) hash
    
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
      let _ = rewrite_ul list in
      ()
        
  end
  )
