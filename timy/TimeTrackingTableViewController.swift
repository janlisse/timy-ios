import UIKit

class TimeTrackingTableViewController: UITableViewController {

    var times = [TimeTracking]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.activityIndicatorView.startAnimating()
        TimeTrackingStore.shared.getTimeTrackings { (timesResult) -> Void in
            switch timesResult {
            case .success:
                self.view.activityIndicatorView.stopAnimating()
                self.times = timesResult.value!
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            case .failure:
                self.showError(timesResult.error!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let time = times[indexPath.row]
        
        print(time.startTime)
        cell.textLabel?.text = formatDate(time.startTime)
        cell.detailTextLabel?.text = "Projekt \(time.projectId): \(time.description)"
        return cell
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    @IBAction func unwindToTimeTrackingList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TimeTrackingViewController,
            let time = sourceViewController.timeTracking {
            times.append(time)
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
