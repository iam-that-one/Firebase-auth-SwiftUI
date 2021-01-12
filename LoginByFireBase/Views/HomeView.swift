//
//  ContentView.swift
//  LoginByFireBase
//
//  Created by Abdullah Alnutayfi on 08/01/2021.
//

import SwiftUI
import Firebase
struct HomeView: View {
    @StateObject var vm = ViewModel()
    @State var showSignInView = false
    @State var logOutSuc = false
    var body: some View {
     
        ZStack{
            Color.white
        
        if showSignInView == false {
            
        VStack{
            VStack{
                Button(action: {
                    logOutSuc.toggle()
                    print("logout successfully")
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    NotificationCenter.default.post(name: NSNotification.Name("isLogin"), object: nil)
                   showSignInView.toggle()
                    //presentationMode.wrappedValue.dismiss()
                    
                } )
                {
                    HStack{
                        Spacer()
                    Text("log out")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    }.frame(width: 375, height: 50).background(Color.green)
                    
                }
            }
         
        ///////////////////////////////////////   View content      ////////////////////////////////////////////
            
            Text("Welcome To Home screen, you did a very good jop to run a way from FireBase Congratulation\(vm.username).")
            
            Spacer()
            
        }.padding()
        .navigationBarHidden(true)
        
    }
    else{
            SignIn()
                .alert(isPresented: $logOutSuc)
                {
                    Alert(title:Text("Message"), message: Text("logout successfully"), dismissButton: .default(Text("Ok")))
                }
        }
        }.edgesIgnoringSafeArea([.bottom,.horizontal])
    }
}


struct HomeView_Preview: PreviewProvider {
    static var viewmodel = ViewModel()
    static var previews: some View {
        HomeView()
    }
}
