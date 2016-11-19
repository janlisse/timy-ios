import UIKit
import Foundation
import Eureka

class TimeTrackingViewController: FormViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingIndicatorView.show("Loading projects")
        TimeTrackingStore.shared.getProjects{ (projects) -> Void in
            TimyData.shared.projects = projects
            LoadingIndicatorView.hide()
            self.renderForm()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderForm() {
        form +++ Section()
            <<< AlertRow<Project>("project") {
                $0.title = "Projekt:"
                $0.selectorTitle = "Projekt"
                $0.options = TimyData.shared.projects
                $0.displayValueFor = {(p) -> String? in return p?.number}
                $0.value = TimyData.shared.projects.first
            }
            <<< TextRow("description"){ row in
                row.title = "Beschreibung:"
                row.placeholder = "Was habe ich getan?"
            }
            <<< TimeRow("start"){
                $0.title = "Start:"
                $0.value = Date().addingTimeInterval(-8 * 60 * 60.0)
            }
            <<< TimeInlineRow("end"){
                $0.title = "Ende:"
                $0.value = Date()
            }
            <<< IntRow("break"){ row in
                row.title = "Pause (Minuten):"
                row.value = 30
            }
            <<< ButtonRow("send") {
                $0.title = "Send"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.send()
        }
    }
    
    func send() {
        form.rowBy(tag: "send")?.disabled = true
        let project = form.rowBy(tag: "project")?.baseValue as? Project
        let description = form.rowBy(tag: "description")?.baseValue as? String
        let start = form.rowBy(tag: "start")?.baseValue as? Date
        let end = form.rowBy(tag: "end")?.baseValue as? Date
        let breakTime = form.rowBy(tag: "break")?.baseValue as? Int
        let timeTracking = TimeTracking(projectId: project!.projectId, description: description!, startTime: start!,
                                        endTime: end!, breakTime: breakTime!)
        TimeTrackingStore.shared.saveTimeTracking(timeTracking: timeTracking){ (success) -> Void in
            self.form.rowBy(tag: "send")?.disabled = false
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}



