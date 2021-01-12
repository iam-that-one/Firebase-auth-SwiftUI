//
//  SignIn.swift
//  LoginByFireBase
//
//  Created by Abdullah Alnutayfi on 09/01/2021.
//


import SwiftUI
import Firebase
struct SignIn: View {
    @StateObject var vm = ViewModel()
    @State private var shouldAnimate = false
    @State var isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool ?? false
    @State var password = ""
    @State var email = ""
    @State var visable = false
    @State var message = ""
    @State var errM = ""
    @State var errr = ""
    @State var showErrorAleart = false
    @State var showSignUp = false

    @State var showHomeScreen = false
    var body: some View {
       
        if self.isLogin == true{
            
            HomeView()
            
        }
        else{
          
        NavigationView{
         
        VStack{
            
            Button(action: {showSignUp.toggle()
                
            }){
                HStack{
                    Spacer()
                Text("Sign up")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                  
                }
            }.padding().background(Color.green.opacity(1))
            ZStack() {
            Color.green
                .opacity(0.10)
                .ignoresSafeArea()
                
                NavigationLink(destination: SignUp(showSignUp: $showSignUp), isActive: $showSignUp){
              
                    Spacer()
                    Text("")
        
                
            }.hidden()
               
                NavigationLink(destination: HomeView(), isActive: $showHomeScreen){
              
                    Spacer()
                    Text("")
        
                
            }.hidden()
            
        ZStack(alignment: .topTrailing){
        
          
            Color.green
                .opacity(0.10)
                .ignoresSafeArea()
        VStack{
            Spacer()
            Image("signIn")
                .resizable()
                .frame(width: 170, height: 170, alignment: .center)
                .foregroundColor(.green)
                .clipShape(Circle())
            Spacer()
        VStack(alignment : .leading){
         
            TextField("email", text: $email)
                .frame(width: 300, height: 50, alignment: .center)
                .autocapitalization(.none)
                .disableAutocorrection(false)
            Divider()
                
                HStack{
                    VStack{
                    if visable {
                        TextField("password", text: $password)
                            .frame(width: 300, height: 50, alignment: .center)
                            .autocapitalization(.none)
                            
                    }
                    else{
                        SecureField("password", text: $password)
                            .frame(width: 300, height: 50, alignment: .center)
                            .autocapitalization(.none)
                        
                    }
                    }
                    Spacer()
                        Button(action: {visable.toggle()}){
                        
                        Image(systemName: visable ? "eye.slash.fill" : "eye.fill")
                          
                            .foregroundColor(Color.green)
                    }
                    
                   
                }
                        
                    Divider()
               
          
            Button(action:{
                if self.email != ""{
                   
                    Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                        
                        if err != nil{
                            message = err!.localizedDescription
                            print(err!.localizedDescription)
                            showErrorAleart.toggle()

                            return
                        }else{
                      
                            message = "The password reset link has been sent successfully to \"\(email)\". Please check your inbox / junk email folder."
                            showErrorAleart.toggle()
                            
                        }
                     
                    }
                    
                }
                
                else if email == "" {
                    message = "Email address must be provided!"
                    showErrorAleart.toggle()
                  
                    return
                }
                
            }){
                HStack{
                    Spacer()
                Text("Forget password")
                    .foregroundColor(Color.green)
                    .fontWeight(.bold)
                }
            }
         
          
       
        
        Button(action: {
            vm.username = email
            let error = validateFields()
            if error != nil{
                errM = error!
               message = validateFields()!
                showErrorAleart.toggle()
                print(error!)
            }
            else{
                //showHomeScreen.toggle()
                Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
                    if error != nil {
                        errr = error!.localizedDescription
                       print(error!.localizedDescription)
                        message = error!.localizedDescription
                    }
                    else if validateFields() == nil && errr == ""{
                        showHomeScreen.toggle()
                        print("login successfully")
                      //  shouldAnimate = true
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        NotificationCenter.default.post(name: NSNotification.Name("isLogin"), object: nil)
                        
                    }
                    
                   
                  }
             
                    }
                }
           
        ){
          
            HStack{
                Spacer()
            Text("Sign In")
                .padding(.horizontal).padding(.vertical,5).padding(.trailing,20)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 30)
                .overlay(Image("signInBtn").resizable().frame(width: 12, height: 12).padding(5).background(Color.white).cornerRadius(5).offset(x: 35, y: 15))
             Spacer()
            }
          
       
        }
        
            .alert(isPresented: $showErrorAleart){
            Alert(title: Text("Message"), message: Text(message), dismissButton: .default(Text("Ok")))
        }
         
            
     
        }.padding(.horizontal).ignoresSafeArea()
            Spacer()
        }
           // HStack{
         //   Text("New?")
              //  .font(Font.system(size: 15, weight: .bold, design: .default))
             //   NavigationLink(destination: SignUp(show: show))
              //  {
              //  Text(" Please Sign up")
                //    .font(Font.system(size: 15, weight: .bold, design: .default))
                //    .foregroundColor(Color.green)
                    
               // }
            //}
            
    }
    }.navigationBarHidden(true)
            
        }
        }.navigationBarHidden(true)
        }

    }
        func validateFields() -> String? {
            if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                password.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                return "please fill in all feilds"
            }
            let validPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
            if isPasswordValid(validPassword) == false{
                return "please make sure your password is at least eight characters, contains a special character and a number."
            }
            if isEmailValid(email.trimmingCharacters(in: .whitespacesAndNewlines)) == false{
                return "email is badly formatted!! \n\"example@example.com\""
            }
            
            return nil
        }
        func isEmailValid(_ email : String) -> Bool{
            let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
            return emailTest.evaluate(with: email)
        }
        func isPasswordValid(_ password : String) -> Bool{
            let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-a\\d$@$#!%*?&]{8,}")
            return passwordTest.evaluate(with: password)
            
        }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
