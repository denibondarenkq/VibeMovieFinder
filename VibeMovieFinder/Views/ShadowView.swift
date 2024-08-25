import UIKit

final class ShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
    }
    
    private func setupShadow() {
        self.backgroundColor = .clear
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 0.2
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
