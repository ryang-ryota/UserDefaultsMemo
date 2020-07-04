//
//  ContentView.swift
//  UserDefaultsMemo
//
//  Created by Ryota on 2020/07/04.
//  Copyright © 2020 Ryota. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //ボタンの有効無効を決めるためのBool型変数
    @State private var isLong: Bool = false
    @State private var isChecked: Bool = false
    
    //メモのテキストとidとその配列
    @State private var inputText: String = ""
    @State private var id = 0
    @State private var memos: [Memo] = []
    
    //入力されたテキストを配列に追加する
    func addMemo(_ i: Int, _ s:String){
        memos.append(Memo(id: i, memo: s))
    }
    
    //配列前削除
    func reset() {
        memos.removeAll()
    }
    
    //配列1行削除
    func remove(offsets: IndexSet) {
        memos.remove(atOffsets: offsets)
    }
    
    let userDefaults = UserDefaults.standard
    
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    
                    //全てはここから始まる。
                    TextField("ここになんか書いてやー", text: $inputText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            if self.userDefaults.stringArray(forKey: "memo") != nil {
                                for i in 0 ..< self.userDefaults.stringArray(forKey: "memos")!.count {
                                    self.id += 1
                                    self.addMemo(self.id, self.userDefaults.stringArray(forKey: "memo")![i])
                                }
                            } else {
                                self.memos = []
                            }
                    }
                    
                    //入力されたメモを追加するボタン
                    Button(action: {
                        if self.inputText.count > 30 {
                            self.isLong = true
                        }else{
                            self.id += 1
                            self.userDefaults.set(self.inputText, forKey: "memo")
                            self.addMemo(self.id, self.inputText)
                            self.inputText = ""
                        }
                    }) {
                        Image(systemName: "plus")
                            .padding()
                    }
                        
                        //テキストが空ならボタンを無効化
                        .disabled(inputText == "" ? true : false)
                        
                        //メモが長すぎたらアラート表示してやり直しさせる
                        .alert(isPresented: $isLong) {
                            Alert(title: Text("長ない？"),
                                  message: Text("一言やてゆーてるやんか"),
                                  dismissButton: .default(Text("ごめんごめん")))
                    }
                }
                
                Divider()
                
                //メモ配列の表示
                List{
                    ForEach(memos){ i in
                        Text(i.memo)
                    }
                    .onDelete(perform: remove)
                }
            }
            .navigationBarTitle("一言メモ", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {                                          //全削除ボタン
                    self.isChecked = true
                }) {Image(systemName: "gobackward")}
                    
                    //メモが一つもなければボタン無効化
                    .disabled(self.memos.isEmpty ? true : false)
                    
                    //全削除する前に毎回アラートで確認
                    .alert(isPresented: $isChecked) {
                        Alert(title: Text("ほんまに？"),
                              message: Text("これぜーんぶ消してええのん？"),
                              primaryButton: .cancel(Text("あかんあかん")),
                              secondaryButton: .destructive(Text("よっしゃ、いてまえ"),
                                                            action: {self.reset()}))
                } ,
                                trailing: EditButton())
        }
    }
}




struct Memo: Identifiable{
    var id: Int
    var memo: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


