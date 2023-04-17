//
//  PostView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 27/03/23.
//

import SwiftUI

protocol onRefreshPost{
    
    func onDeletePost()
}

struct PostView: View {
    
    
    @State var post : PostModel
    @State var likeAnimation : Bool = false
    @State var dissLikeAnimation : Bool = false
    @State var addHeartAnimationToView : Bool
    @State var showActionSheet : Bool  = false

    @State var profileImage : UIImage = UIImage(named: .logoLoading)!
    @State var postImage : UIImage = UIImage(named: .logoLoading)!
    
    @AppStorage(CurrentUserDefaults.userId) var currentUserId : String?

    //ALERT
    
    @State var alertTitle : String = ""
    @State var alertMessage : String = ""
    @State var showReportAlert : Bool = false
    @State var sendToOnboard : Bool = false

    
    var showHeaderAndFooter : Bool
    @State var actionSheetType : PostActionSheetOption = PostActionSheetOption.general
    @State var isAnimationaTabView : Bool = false
        
    var delegate : onRefreshPost?

    
    var body: some View {

        VStack(alignment: .center,spacing: 0) {
            
            //MARK: Header
            if showHeaderAndFooter {
                HStack {
                    NavigationLink (destination: LazzyView(content: {
                      
                        ProfileView(profileDisplayName: post.userName, profileUserId: post.userId,isMyProfile: false, postArrayObj: PostArrayObject(userId: post.userId))

                    }) ,
                        label: {
                        Image(uiImage: profileImage)
                            .resizable().scaledToFill().frame(width: 30,height: 30,alignment: .center).cornerRadius(15)
                        Text(post.userName).font(.callout).fontWeight(.medium).foregroundColor(.primary)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        if currentUserId != nil {
                           
                            if currentUserId == post.userId
                            {
                                actionSheetType =  .PersonalPostRelated
                            }
                            else{
                                actionSheetType =  .general

                            }
                            showActionSheet.toggle()
                        }
                        else{
                            sendToOnboard.toggle()
                        }

                    }, label: {
                        Image(systemName: "ellipsis").font(.headline)

                    })
                    .accentColor(.primary)
                    .actionSheet(isPresented: $showActionSheet, content: {
                        getActionSheet()
                    })
                }.padding(.all,6)
            }

            //MARK: Image
            ZStack{
             
            if isAnimationaTabView {
                    
                    Image(uiImage: postImage)
                        .resizable()
                        .scaledToFill()
                        .onTapGesture(count: 2, perform: {
                            if !post.likedByUser{
                               likePost()
                               AnalyaticsService.instance.likePostDoubleTap()
                            }
                        })

                }
                else{
                    Image(uiImage: postImage)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture(count: 2, perform: {
                            if !post.likedByUser{
                                likePost()
                                AnalyaticsService.instance.likePostDoubleTap()
                            }
                        })
                }
                
                if addHeartAnimationToView{
                    LikeAnimationView(animate: $likeAnimation, dissLike: $dissLikeAnimation)
                }
            }
            
            //MARK: Footer
            if showHeaderAndFooter {
                HStack(alignment: .center,spacing: 20, content: {
                    Button(action: {
                        if currentUserId != nil {
                            
                            if post.likedByUser {
                                //UNLIKE
                                unLikePost()
                            }
                            else{
                                //Like Post
                                likePost()
                                AnalyaticsService.instance.likePostHeartPressed()
                            }

                        }
                        else{
                            
                            sendToOnboard.toggle()
                        }
                        
                    }, label: {
                        Image(systemName: post.likedByUser ? "heart.fill"  : "heart").font(.title3)

                    })
                    .accentColor(post.likedByUser ? .red : .primary)
                    //MARK: Comment Icon
                    
                    if currentUserId != nil {
                        
                        NavigationLink(destination: CommentsView(post: post) ,label:{
                           
                            Image(systemName: "bubble.middle.bottom").font(.title3)
                                .foregroundColor(.primary)

                        })
                    }
                    else{
                      
                        Button(action: {
                            sendToOnboard.toggle()
                        }, label: {
                            Image(systemName: "bubble.middle.bottom").font(.title3)
                                .foregroundColor(.primary)
                        })
                        .accentColor(.primary)

                    }
                  
                    Button(action: {
                        if currentUserId != nil {
                           
                            sharePost()

                        }
                        else{
                            sendToOnboard.toggle()
                        }
                    }, label: {
                        Image(systemName: "paperplane").font(.title3)
                    })
                    .accentColor(.primary)
                   
                    Spacer()
                    
                }).padding(.all,6)
                
                if let caption = post.caption{
                    HStack {
                        Text(caption)
                        Spacer(minLength: 0)
                    }
                    .padding(.all,6)
                }
            }
        }
        .fullScreenCover(isPresented: $sendToOnboard,onDismiss: nil, content: {
            
            OnboardingView()
        })
        .onAppear{
            getPostByID()
            //getPostLike()
            getImages()
        }
        .alert(isPresented: $showReportAlert) {
            return Alert(title: Text(alertTitle),message: Text(alertMessage),dismissButton: .default(Text("OK")))
        }
    }
    
    //MARK: FUNCTIONS
    
    func getPostByID(){
    
        DataService.instance.getPostByPostID(postId: post.postId, userId: post.userId) { postModel in
            guard let _post = postModel else{return}
            
            self.post = _post
        }
    }
    
    func getPostLike(){
        
        guard let _currentUserId = currentUserId else{return}
        DataService.instance.getPostByPostIdLikeByUser(postId: post.postId, userId: _currentUserId) { sucess in
            
            self.post.likedByUser  = sucess
        }
        
        
    }
    
    func getImages(){
       
        // get profile Image
        
        ImageManager.instance.downloadProfileImage(userId: post.userId) { returnImage in
            
            if let img = returnImage{
                
                self.profileImage = img
            }
        }
        
        // get Post Image

        ImageManager.instance.downloadPostImg(postId: post.postId) { returnImage in
          
            if let img = returnImage{
                
                self.postImage = img
            }
        }
    }
    
    func likePost(){
        guard let _currentUserId = currentUserId else{
            print("Can't fint user Id while liking post")
            return
        }

        //Update local data
        let updatedPost = PostModel(postId: post.postId, userId: post.userId, userName: post.userName,caption: post.caption, dateCreated: Date(), likeCount: (post.likeCount + 1), likedByUser: true)
        self.post = updatedPost
        
        likeAnimation = true
        dissLikeAnimation = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            likeAnimation = false
        })
        
        // update Database
        DataService.instance.likePost(postId: post.postId, currentUserID: _currentUserId)
    }
    
    func unLikePost(){
        guard let _currentUserId = currentUserId else{
            print("Can't fint user Id while unliking post")
            return
        }

        //Update local data
        let updatedPost = PostModel(postId: post.postId, userId: post.userId, userName: post.userName,caption: post.caption, dateCreated: Date(), likeCount: (post.likeCount - 1), likedByUser: false)
        self.post = updatedPost
        
       
        // update Database

        DataService.instance.unLikePost(postId: post.postId, currentUserID: _currentUserId)

        
        // Disslike Animation
        likeAnimation = true
        dissLikeAnimation = true
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            likeAnimation = false
            dissLikeAnimation = false
        })

        
    }
    
    func getActionSheet()->ActionSheet{
        switch actionSheetType{
            
        case.general :
            return ActionSheet(title: Text("What would you like to do?"),message: nil,buttons: [
                
                .destructive(Text("Report"),action: {
                   
                    self.actionSheetType = .reported
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                        self.showActionSheet.toggle()

                    })

                }),
                .default(Text("Learn more..."),action: {
                  
                    print("LEARN MORE PRESSED")
                }),
                
                .cancel()
            ])
        case .PersonalPostRelated :
            
            return ActionSheet(title: Text("What would you like to do?"),message: nil,buttons: [
                
                .destructive(Text("Report"),action: {
                   
                    self.actionSheetType = .reported
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                        self.showActionSheet.toggle()

                    })

                }),
                .destructive(Text("Delete Post"),action: {
                  
                    print("Delete Post")
                    deletePost()
                }),

                .default(Text("Learn more..."),action: {
                  
                    print("LEARN MORE PRESSED")
                }),

                .cancel()
            ])


        case .reported :
            
            return ActionSheet(title: Text("Why you reporting this post?"),message: nil,buttons: [
                .destructive(Text("This is inappropriate"),action: {
                    reportPost(reason:"This is inappropriate")
                }),
                .destructive(Text("This is spam"),action: {
                    reportPost(reason:"This is spam")
                }),
                .destructive(Text("It made me uncomfortable"),action: {
                    reportPost(reason:"It made me uncomfortable")
                }),
                .cancel({
                    self.actionSheetType = .general
                })
            ])
        }
    }
    
    func deletePost(){
        
        print("deleted postID\(post.postId)")
        
        DataService.instance.deletePost(postId: post.postId) { Success in
          
            guard let _delegate = self.delegate else{return}

            _delegate.onDeletePost()
            
        }
    }
    func reportPost(reason :String){
        print("REPORT POST NOW")
        DataService.instance.uploadReport(reason: reason, postId: post.postId) { success in
            
            if success{
                
                self.alertTitle = "REPORTED"
                self.alertMessage = "Thanks for reporting this post. We will review it shortly and take the appropriate action!"
                showReportAlert.toggle()
            }
            else{
                self.alertTitle = "ERROR"
                self.alertMessage = "There is error while reporting this post. Please restart and try again"
                showReportAlert.toggle()
                print("FAILD TO REPORT")
            }
        }
    }
    
    func sharePost(){
       
        let msg = "Check out This Post"
        let image = postImage
        let link = URL(string: "https://www.google.com")!
        let activityVC = UIActivityViewController(activityItems: [msg,image,link], applicationActivities: nil)
        let vc =  UIApplication.shared.windows.first?.rootViewController
        vc?.present(activityVC, animated: true,completion: nil)
    }
}


struct PostView_Previews: PreviewProvider {
    static var postMdl : PostModel = PostModel(postId: "", userId: "", userName: "Pooja",caption: "This is test caption",dateCreated: Date(), likeCount: 1, likedByUser: false)
    static var showHeaderAndFooter : Bool = true
  
    static var previews: some View {
        PostView(post:postMdl, addHeartAnimationToView: true, showHeaderAndFooter: showHeaderAndFooter).previewLayout(.sizeThatFits)
        
    }
}
