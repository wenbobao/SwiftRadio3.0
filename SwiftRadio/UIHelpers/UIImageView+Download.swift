
import UIKit

extension UIImageView {
    
    func loadImageWithURL(url: URL, callback:@escaping (UIImage) -> Void) -> URLSessionDownloadTask {

        let downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            (data, response, error) -> Void in
            
            if error == nil {
                
                let data = try? Data(contentsOf: url)
                
                if let image = UIImage(data: data!) {
                    
                    DispatchQueue.main.async {
                        
                        self.image = image;
                        callback(image)
                        
//                        if let strongSelf = self {
//                            strongSelf.image = image
//                            callback(image)
//                        }
                        
                    }
                    
                }
            }
            
        })
        
        downloadTask.resume()
        return downloadTask
    }
}


