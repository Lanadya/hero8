import Foundation
import UIKit
import SwiftUI
import os.log

/**
 Ein Thread-sicherer Asset-Manager zur Vermeidung von CUICatalog-Fehlern.
 
 Diese Klasse stellt Thread-sichere Methoden für den Zugriff auf Farben und Bilder
 bereit und löst das bekannte CUICatalog-Problem in iOS-Apps.
 */
public class ThreadSafeAssetManager {
    // MARK: - Properties
    
    /// Die Singleton-Instanz des Asset-Managers
    public static let shared = ThreadSafeAssetManager()
    
    /// Logger für Diagnosezwecke
    private let logger = Logger(subsystem: "com.teccolino.hero8", category: "AssetManager")
    
    /// Thread-sichere Caches für Farben und Bilder
    private let colorCache = NSCache<NSString, UIColor>()
    private let imageCache = NSCache<NSString, UIImage>()
    private let cacheLock = NSLock()
    
    /// Speichert, ob das Asset-System bereits initialisiert wurde
    private var assetSystemInitialized = false
    
    // MARK: - Initialization
    
    private init() {
        setupCaches()
    }
    
    // MARK: - Public API
    
    /**
     Initialisiert das Asset-System. Diese Methode sollte früh im App-Lebenszyklus aufgerufen werden.
     */
    public func initialize() {
        guard !assetSystemInitialized else {
            logger.notice("Asset-System wurde bereits initialisiert")
            return
        }
        
        logger.notice("Initialisiere Thread-sicheres Asset-System")
        
        // Initialisierung im Hauptthread
        initializeInMainThread()
        
        // Thread-spezifische Sicherheitsmaßnahmen
        setupThreadSafety()
        
        // Häufig verwendete Assets vorladen
        preloadCommonAssets()
        
        assetSystemInitialized = true
        logger.notice("Asset-System erfolgreich initialisiert")
    }
    
    /**
     Eine Thread-sichere Alternative zu UIColor(named:).
     
     - Parameter name: Der Name der Farbe im Asset-Katalog
     - Returns: Die gefundene Farbe oder eine Fallback-Farbe
     */
    public func color(named name: String?) -> UIColor {
        guard let name = name, !name.isEmpty else {
            return UIColor.systemGray
        }
        
        let key = name as NSString
        
        // Versuche, die Farbe aus dem Cache zu laden
        cacheLock.lock()
        if let cachedColor = colorCache.object(forKey: key) {
            cacheLock.unlock()
            return cachedColor
        }
        cacheLock.unlock()
        
        // Farbe laden
        let color: UIColor
        
        if Thread.isMainThread {
            // Im Hauptthread direkt laden
            color = UIColor(named: name) ?? fallbackColor(for: name)
        } else {
            // Von anderen Threads zum Hauptthread wechseln
            var resultColor: UIColor?
            
            DispatchQueue.main.sync {
                resultColor = UIColor(named: name) ?? self.fallbackColor(for: name)
            }
            
            color = resultColor ?? UIColor.systemGray
        }
        
        // Farbe im Cache speichern
        cacheLock.lock()
        colorCache.setObject(color, forKey: key)
        cacheLock.unlock()
        
        return color
    }
    
    /**
     Eine Thread-sichere Alternative zu UIImage(named:).
     
     - Parameter name: Der Name des Bildes im Asset-Katalog
     - Returns: Das gefundene Bild oder ein Fallback-Bild
     */
    public func image(named name: String?) -> UIImage {
        guard let name = name, !name.isEmpty else {
            return UIImage(systemName: "questionmark.circle") ?? UIImage()
        }
        
        let key = name as NSString
        
        // Versuche, das Bild aus dem Cache zu laden
        cacheLock.lock()
        if let cachedImage = imageCache.object(forKey: key) {
            cacheLock.unlock()
            return cachedImage
        }
        cacheLock.unlock()
        
        // Bild laden
        let image: UIImage
        
        if Thread.isMainThread {
            // Im Hauptthread direkt laden
            if let loadedImage = UIImage(named: name) {
                image = loadedImage
            } else if let systemImage = UIImage(systemName: name) {
                image = systemImage
            } else {
                image = UIImage(systemName: "questionmark.circle") ?? UIImage()
            }
        } else {
            // Von anderen Threads zum Hauptthread wechseln
            var resultImage: UIImage?
            
            DispatchQueue.main.sync {
                if let loadedImage = UIImage(named: name) {
                    resultImage = loadedImage
                } else if let systemImage = UIImage(systemName: name) {
                    resultImage = systemImage
                } else {
                    resultImage = UIImage(systemName: "questionmark.circle")
                }
            }
            
            image = resultImage ?? UIImage()
        }
        
        // Bild im Cache speichern
        cacheLock.lock()
        imageCache.setObject(image, forKey: key)
        cacheLock.unlock()
        
        return image
    }
    
    // MARK: - Private Methods
    
    /**
     Richtet die Asset-Caches ein.
     */
    private func setupCaches() {
        colorCache.countLimit = 100
        imageCache.countLimit = 50
        
        // Bei Memory-Warnungen Caches leeren
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.clearCaches()
        }
    }
    
    /**
     Leert alle Asset-Caches.
     */
    private func clearCaches() {
        cacheLock.lock()
        colorCache.removeAllObjects()
        imageCache.removeAllObjects()
        cacheLock.unlock()
        logger.debug("Asset-Caches geleert")
    }
    
    /**
     Gibt eine Fallback-Farbe zurück, wenn eine Farbe nicht gefunden wird.
     
     - Parameter name: Der Name der Farbe
     - Returns: Eine passende Systemfarbe
     */
    private func fallbackColor(for name: String) -> UIColor {
        switch name.lowercased() {
        case "accent", "accentcolor":
            return .systemBlue
        case "primary", "primarycolor":
            return .label
        case "secondary", "secondarycolor":
            return .secondaryLabel
        case "background", "backgroundcolor":
            return .systemBackground
        case "red", "rot":
            return .systemRed
        case "green", "grün":
            return .systemGreen
        case "blue", "blau":
            return .systemBlue
        case "yellow", "gelb":
            return .systemYellow
        case "orange":
            return .systemOrange
        case "purple", "lila":
            return .systemPurple
        case "gray", "grey", "grau":
            return .systemGray
        default:
            return .systemGray
        }
    }
    
    /**
     Initialisiert das Asset-System im Hauptthread.
     */
    private func initializeInMainThread() {
        if Thread.isMainThread {
            // Direkt im Hauptthread ausführen
            logger.debug("Initialisiere Asset-System im Hauptthread")
            initializeAssetSystem()
        } else {
            // Zum Hauptthread wechseln
            logger.debug("Wechsle zum Hauptthread für Asset-Initialisierung")
            DispatchQueue.main.sync {
                self.initializeAssetSystem()
            }
        }
    }
    
    /**
     Führt die eigentliche Asset-System-Initialisierung durch.
     */
    private func initializeAssetSystem() {
        autoreleasepool {
            // System-Assets laden, um das Asset-System zu initialisieren
            _ = UIColor.systemBackground
            _ = UIColor.systemBlue
            _ = UIColor.systemGray
            _ = UIImage(systemName: "star")
            _ = UIImage(systemName: "circle")
            _ = UIImage(systemName: "questionmark.circle")
            
            logger.debug("System-Assets geladen")
        }
    }
    
    /**
     Richtet Thread-spezifische Sicherheitsmaßnahmen ein.
     */
    private func setupThreadSafety() {
        // Dedizierter Thread für Asset-Initialisierung
        Thread.detachNewThread { [weak self] in
            autoreleasepool {
                // Grundlegende Assets laden
                _ = UIColor.systemBackground
                _ = UIImage(systemName: "star")
                
                // Thread-sicheren Schlüssel setzen
                Thread.current.threadDictionary["AssetSystemInitialized"] = true
                
                if let self = self {
                    // Zum Hauptthread für Logging zurückkehren
                    DispatchQueue.main.async {
                        self.logger.debug("Thread-sicherer Asset-Kontext initialisiert")
                    }
                }
            }
        }
        
        // Zusätzliche Initialisierung in Hintergrund-Queues
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            autoreleasepool {
                // Grundlegende Assets laden
                _ = UIColor.systemBackground
                _ = UIImage(systemName: "circle")
                
                if let self = self {
                    // Zum Hauptthread für Logging zurückkehren
                    DispatchQueue.main.async {
                        self.logger.debug("Asset-Kontext in globalem Queue initialisiert")
                    }
                }
            }
        }
    }
    
    /**
     Lädt häufig verwendete Assets vor.
     */
    private func preloadCommonAssets() {
        // Häufig verwendete Farben
        let commonColorNames = [
            "AccentColor",
            "primary",
            "secondary",
            "background"
        ]
        
        // Häufig verwendete System-Bilder
        let commonSystemImages = [
            "person.circle",
            "gear",
            "checkmark.circle",
            "xmark.circle",
            "questionmark.circle"
        ]
        
        // Assets in einem Hintergrund-Thread mit niedriger Priorität laden
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            // Assets in einem autoreleasepool laden
            autoreleasepool {
                // Farben vorab laden
                for colorName in commonColorNames {
                    _ = self.color(named: colorName)
                }
                
                // System-Bilder vorab laden
                for systemImageName in commonSystemImages {
                    _ = UIImage(systemName: systemImageName)
                }
                
                // Zum Hauptthread für Logging zurückkehren
                DispatchQueue.main.async {
                    self.logger.debug("Häufig verwendete Assets wurden vorab geladen")
                }
            }
        }
    }
}

// MARK: - SwiftUI Extensions

/**
 SwiftUI-Erweiterungen für sichere Asset-Zugriffe.
 */
public extension Color {
    /**
     Eine sichere Alternative zu Color(named:).
     
     - Parameter name: Der Name der Farbe im Asset-Katalog
     - Returns: Die gefundene Farbe oder eine Fallback-Farbe
     */
    static func safe(_ name: String) -> Color {
        Color(uiColor: ThreadSafeAssetManager.shared.color(named: name))
    }
}

public extension Image {
    /**
     Eine sichere Alternative zu Image(named:).
     
     - Parameter name: Der Name des Bildes im Asset-Katalog
     - Returns: Das gefundene Bild oder ein Fallback-Bild
     */
    static func safe(_ name: String) -> Image {
        Image(uiImage: ThreadSafeAssetManager.shared.image(named: name))
    }
}
