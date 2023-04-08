//
//  ProfileView.swift
//  SwiftUiAdvanced
//
//  Created by Brenda Saavedra  on 04/04/23.
//

import SwiftUI
import RevenueCat
import FirebaseAuth
import CoreData

struct ProfileView: View {
    @State private var showLoader: Bool = false
    @State private var iapButtonTitle = "Purchase Lifetime Pro Plan"
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlertView = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showSettingsView: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], predicate: NSPredicate(format: "userID == %@", Auth.auth().currentUser!.uid), animation: .default) private var savedAccounts: FetchedResults<Account>
    @State private var currentAccount: Account?
    @State private var updater: Bool = true
    
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        if currentAccount?.profileImage != nil {
                            GradientProfilePictureView(profilePicture: UIImage(data: currentAccount!.profileImage!)!)
                                .frame(width: 66, height: 66)
                        } else {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("pink-gradient-1"))
                                    .frame(width: 66, height: 66, alignment: .center)
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .medium, design: .rounded))
                            }
                            .frame(width: 66, height: 66, alignment: .center)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(currentAccount?.name ?? "No name")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            Text("View profile")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showSettingsView.toggle()
                        }, label: {
                            TextFieldIcon(iconName:"gearshape.fill", currentlyEditing: .constant(true), passedImage: .constant(nil))
                        })
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text(currentAccount?.bio ?? "No Bio")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    if currentAccount?.numerOfCertificates != 0 {
                        Label("Awarded \(currentAccount?.numerOfCertificates ?? 0) certificates since \(dateFormatter(currentAccount?.userSince ?? Date()))", systemImage: "calendar")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    HStack(spacing: 16) {
                        if currentAccount?.twitterHandle != nil {
                            Image("Twitter")
                                .resizable()
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 24, height: 24, alignment: .center)
                        }
                        
                        if currentAccount?.website != nil {
                            Image(systemName: "link")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                            Text(currentAccount?.website ?? "No website")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                    }
                }
                .padding(16)
                
                GradientButton(buttonTitle: iapButtonTitle, buttonAction: {
                    if currentAccount?.proMember != true {
                        showLoader = true
                        Purchases.shared.getOfferings { offerings, error in
                            if let packages = offerings?.current?.availablePackages {
                                Purchases.shared.purchase(package: packages.first!) { transaction, purchaserInfo, error, userCancelled in
                                    print("TRANSACTION: \(transaction)")
                                    print("PURCHASER INFO: \(purchaserInfo)")
                                    print("ERROR: \(error)")
                                    print("USERCANCELLED: \(userCancelled)")
                                    
                                    if purchaserInfo?.entitlements["pro"]?.isActive == true {
                                        currentAccount?.proMember = true
                                        iapButtonTitle = "You are a Pro Member"
                                        
                                        do {
                                            try viewContext.save()
                                            showLoader = false
                                            alertTitle = "Purchase Successful"
                                            alertMessage = "You are now a pro member"
                                            showAlertView.toggle()
                                        } catch let error {
                                            alertTitle = "Uh-oh!"
                                            alertMessage = error.localizedDescription
                                            showAlertView.toggle()
                                            showLoader = false
                                        }
                                    } else{
                                        showLoader = false
                                        alertTitle = "Purchase Failed"
                                        alertMessage = "You are not a pro member"
                                        showAlertView.toggle()
                                    }
                                }
                            } else{
                                showLoader = false
                            }
                        }
                    } else {
                        alertTitle = "No Purchase Necessary"
                        alertMessage = "You are already a pro member"
                        showAlertView.toggle()
                    }
                })
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 30)
                
                Button(action:{
                    showLoader = true
                    Purchases.shared.restorePurchases { purchaserInfo, error in
                        if let info = purchaserInfo {
                            if info.allPurchasedProductIdentifiers.contains("lifetim_pro_plan") {
                                currentAccount?.proMember = true
                                do {
                                    try viewContext.save()
                                    iapButtonTitle = "You are a Pro Member"
                                    alertTitle = "Restore Success"
                                    alertMessage = "Your purchase has been restored and you are a pro member"
                                    showAlertView.toggle()
                                    showLoader = false
                                } catch let error {
                                    alertTitle = "Restore Unsuccessful"
                                    alertMessage = error.localizedDescription
                                    showAlertView.toggle()
                                    showLoader = false
                                }
                            } else {
                                alertTitle = "No Purchases Found"
                                alertMessage = "Your purchase has not been restored and you are not a pro member"
                                showAlertView.toggle()
                            }
                        } else {
                            showLoader = false
                            alertTitle = "Restore Failed"
                            alertMessage = "Your purchase has not been restored and you are not a pro member"
                            showAlertView.toggle()
                        }
                    }
                }, label: {
                    GradientText(text:"Restore Purchases").font(.footnote.bold())
                })
                .padding(.bottom)
                
                Spacer().frame(height: 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .dark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 60)
            )
            .cornerRadius(30)
            .padding(.horizontal)
            
            VStack {
                Spacer()
                Button(action: {
                    signout()
                }, label: {
                    Image(systemName: "arrow.turn.up.forward.iphone.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0.0, y: 0.0, z:1.0))
                        .background(
                            Circle()
                                .stroke( Color.white.opacity(0.2), lineWidth: 1 )
                                .frame(width: 42, height: 42, alignment: .center)
                                .overlay(
                                    VisualEffectBlur(blurStyle: .dark)
                                        .cornerRadius(21)
                                        .frame(width: 42, height: 42, alignment: .center)
                                )
                        )
                })
            }
            .padding(.bottom, 64)
            
            if showLoader {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .colorScheme(updater ? .dark : .dark)
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
        }
        .sheet(isPresented: $showSettingsView, content: {
            SettingsView()
                .environment(\.managedObjectContext, self.viewContext)
                .onDisappear() {
                    currentAccount = savedAccounts.first!
                    updater.toggle()
                }
        })
        .onAppear() {
            currentAccount = savedAccounts.first
            
            if currentAccount == nil {
                let userDataToSave = Account(context: viewContext)
                userDataToSave.name = Auth.auth().currentUser!.displayName
                userDataToSave.bio = nil
                userDataToSave.userID = Auth.auth().currentUser!.uid
                userDataToSave.numerOfCertificates = 0
                userDataToSave.proMember = false
                userDataToSave.twitterHandle = nil
                userDataToSave.website = nil
                userDataToSave.profileImage = nil
                userDataToSave.userSince = Date()
                do {
                    try viewContext.save()
                } catch let error {
                    alertTitle = "Could not create an account"
                    alertMessage = error.localizedDescription
                    showAlertView.toggle()
                }
            }
            
            if currentAccount?.proMember == false {
                Purchases.shared.getOfferings { offerings, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    if let allOfferings = offerings, let lifetimePurchase = allOfferings.current?.lifetime {
                        iapButtonTitle = "Purchase Lifetime Pro Plan - \(lifetimePurchase.localizedPriceString)"
                    }
                }
            } else {
                iapButtonTitle = "You are a Pro Member"
            }
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            presentationMode.wrappedValue.dismiss()
        } catch let error {
            alertTitle = "Uh-Oh!"
            alertMessage = error.localizedDescription
            showAlertView.toggle()
        }
    }
    
    func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
