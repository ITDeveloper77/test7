//
//  ViewController.swift
//  speechRec
//
//  Created by macbook on 19.09.2022.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var mySpeechTextView: UITextView!
    
    
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBOutlet weak var colorView: UIView!
    
    let textToSpeech = TextToSpeech()//ссылка на класс
    var text = "Зеленый, заяц увидел красный закат ошибка"
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        //ставим наблюдателя за словами при чтении текста (наблюдатель отслеживает нотификейшны(события) по ключу ластворд и только если что то появляется по этому ключу то срабатывает селектор функция #selector(catchWord) )
        NotificationCenter.default.addObserver(self, selector: #selector(catchWord), name: NSNotification.Name("lastWord"), object: nil)
        
        mySpeechTextView.text = text
        
        
    }
//функция реакции на появившееся слово в нотифкейшн центре по ключу ластворд
    @objc func catchWord(notification: Notification) {
        //из нотификации вылавливаем наш стринг слово
        guard var text = notification.object as? String else {return}
        //из нашего пойманого слова проверяем последний символ на знаки препинания
        if let lastChar = text.last {
            if [",", ".","!", "?", "-"].contains(lastChar) { //задаем массив знаков для удалпения
                text = String(text.dropLast())//при наличии знака из массива мы его удаляем из слова
            }
        }
        //функция реакции на конретныеи слова ловеркейс для того что бы на заглавные буквы не обращалось внимание
        chekWord(lastString: text.lowercased())
        
    }
    
    //функция реакции на конретные слова можем сделать любое действие в кейсах
    func chekWord(lastString: String) {
        switch lastString {
        case "зеленый":
            self.colorView.backgroundColor = .green
        case "красный":
            self.colorView.backgroundColor = .red
         
        case "черный":
            self.colorView.backgroundColor = .black
           
//        case "ошибка":
//           // fatalError()
            
        default: break
        }
        
    }
    
    
    
    
    
    

    @IBAction func startButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        if textToSpeech.isSpeack {
            textToSpeech.pauseSpeech()
        } else {
            textToSpeech.contineSpeech()
        }
    }
    
    
    @IBAction func talkButtonAction(_ sender: UIButton) {
        
        textToSpeech.talkText(text: mySpeechTextView.text)
    }
    
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        
        textToSpeech.stopSpeech()
    }
    
    
}

