//
//  SignUp.swift
//  LoginByFireBase
//
//  Created by Abdullah Alnutayfi on 08/01/2021.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
struct SignUp: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var firstname = ""
    @State var lastname = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var email = ""
    @State var showErrorAleart = false
    @State var signUpScc = false
    @State var isReadyToNavigateToHomePage = false
    @State var visable = false
    @State var message = ""
    @Binding var showSignUp : Bool
    var body: some View {
        ZStack{
            Color.green
                .opacity(0.10)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Image("new")
                    .resizable()
                    .frame(width: 170, height: 170, alignment: .center)
                    .foregroundColor(.green)
                    .clipShape(Circle())
                VStack(alignment : .leading){
                    Group{
                        
                        TextField("email", text: $email)
                            .frame(width: 300, height: 50, alignment: .center)
                            .autocapitalization(.none)
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
                            Button(action: {visable.toggle()}){
                                Image(systemName: visable ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color.green)
                            }
                        }
                        Divider()
                        HStack{
                            VStack{
                                if visable {
                                    TextField("confirm password", text: $confirmPassword)
                                        .frame(width: 300, height: 50, alignment: .center)
                                        .autocapitalization(.none)
                                }
                                else{
                                    SecureField("confirm password", text: $confirmPassword)
                                        .frame(width: 300, height: 50, alignment: .center)
                                        .autocapitalization(.none)
                                }
                            }
                        }
                        Divider()
                        TextField("firstname", text: $firstname)
                            .frame(width: 300, height: 50, alignment: .center)
                        Divider()
                        TextField("lastname", text: $lastname)
                            .frame(width: 300, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Divider()
                    }
                    
                
                }.padding()
                
                Button(action: {
                    
                    let error = validateFields()
                    if error != nil{
                        message = validateFields()!
                        showErrorAleart.toggle()
                        print(error!)
                    }
                    else {
                        Auth.auth().createUser(withEmail:  email.trimmingCharacters(in: .whitespacesAndNewlines), password: password.trimmingCharacters(in: .whitespacesAndNewlines)) { (result, err) in
                            if  err != nil {
                                message = err!.localizedDescription
                                showErrorAleart.toggle()
                            }
                            else{
                                // Create user now
                                let db = Firestore.firestore()
                                db.collection(("users")).addDocument(data: ["firstname":firstname.trimmingCharacters(in: .whitespacesAndNewlines), "lastname": lastname.trimmingCharacters(in: .whitespacesAndNewlines), "uid": result!.user.uid]) { (error) in
                                    
                                    if error != nil{
                                        message = error!.localizedDescription
                                        showErrorAleart.toggle()
                                    }
                                    else{
                                        message = "Sign up successfully, press \"OK\" and sign in"
                                        self.presentationMode.wrappedValue.dismiss()
                                        //  signUpScc.toggle()
                                        showErrorAleart.toggle()
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }){
                    Text("Sign up")
                        .padding(.horizontal).padding(.vertical,5).padding(.trailing,20)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(Image(systemName: "arrow.up.right.square").foregroundColor(.white).offset(x: 35))
                    
                    
                    
                }.alert(isPresented: $showErrorAleart){
                    Alert(title: Text("Warning"), message: Text(message), dismissButton: .default(Text("Ok")))
                    
                }.navigationBarHidden(true) ////////////////////////////////////////////////////////////////////////////////////
                Spacer()
                HStack{
                    Text("Have an account?")
                        .font(Font.system(size: 15, weight: .bold, design: .default))
                    NavigationLink(destination: SignIn())
                    {
                        Text(" Sign in")
                            .font(Font.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(Color.green)
                        
                    }
                }
            }
            
        }
        
    }
    func validateFields() -> String? {
        if firstname.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
            lastname.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "please fill in all feilds"
        }
        let validPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(validPassword) == false{
            return "please make sure your password is at least eight characters, contains a special connector and a number."
        }
        if isEmailValid(email) == false{
            return "email is badly formatted!! \n\"example@example.com\""
        }
        if password != confirmPassword {
            return "password does not match"
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


