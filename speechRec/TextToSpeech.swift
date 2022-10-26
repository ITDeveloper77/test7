//
//  TextToSpeech.swift
//  speechRec
//
//  Created by macbook on 19.09.2022.
//


import AVFoundation

extension Notification.Name { //создаем переменую которая отвечает за имя нотификации и назначаем ей ключ по ключу ловят слова
    static let lastWord = Notification.Name("lastWord")
}


class TextToSpeech: NSObject, AVSpeechSynthesizerDelegate {
 
    var speechSynthesizer = AVSpeechSynthesizer()
    var audiosession = AVAudioSession.sharedInstance()
    
    var isSpeack = false //отвечает за то что идет воспроизведение (для паузы)
    var isStart = false //отвечает начало воспроизведения (нужно для стопа)
    
    var rate: Float = 0.4 //темп воспроизведения
    var volume: Float = 1 //громкость
    var pitchMultiplayer: Float = 0.8 //тембр
    var voice = AVSpeechSynthesisVoice(language: Locale.current.currencyCode) //язык по умолчанию региона или в кавычках указываем сами
    
    
    override init() {
        super.init()
        self.speechSynthesizer.delegate = self
    }
    
    func talkText(text: String) {
        do {
            try audiosession.setCategory(.playAndRecord, mode: .spokenAudio, options: .mixWithOthers) //нфстройка аудиопотока
            try audiosession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = self.voice
            utterance.rate = self.rate
            utterance.volume = self.volume
            utterance.pitchMultiplier = self.pitchMultiplayer
            self.speechSynthesizer.speak(utterance)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
        func stopSpeech() {
            self.speechSynthesizer.stopSpeaking(at: .immediate)
            self.isStart = false
        }
 
        func pauseSpeech() {
            self.speechSynthesizer.pauseSpeaking(at: .word)
        }
        
        func contineSpeech() {
            self.speechSynthesizer.continueSpeaking()
        }
        
    //MARK: функции делегата
        
     

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart")
        self.isSpeack = true
        self.isStart = true
    }
        
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish")
        self.isSpeack = false
        self.isStart = false
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("didPause")
        self.isSpeack = false
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print("didContinue")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("didCancel")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        //вытаскиваем текущее прогавариваемое слово subString
        let subString = (utterance.speechString as NSString).substring(with: characterRange)
        print("\(characterRange), text: \(subString)")
        
        //отправляем по одному слову (subString) в нотификейшн центр в переменую lastWord
        NotificationCenter.default.post(name: Notification.Name.lastWord, object: subString)
        
        
    }
}













