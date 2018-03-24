class MobileController < ApplicationController
    skip_before_filter :verify_authenticity_token
    before_action :verify_session_token, except: ['login','facebook','push_send']
    
    def list 
        if params[:lat] and params[:lng]
            latDelta = 0.0922
            lngDelta = 0.0421
            
            minLat = params[:lat].to_f - latDelta
            maxLat = params[:lat].to_f + latDelta
            minLng = params[:lng].to_f - lngDelta
            maxLng = params[:lng].to_f + lngDelta
            
            @spots = Restaurant.where("lat >= ? AND lat <= ?", minLat, maxLat).where("lng >= ? AND lng <= ?", minLng, maxLng).paginate(page: params[:page], per_page: 20)
        else 
            @spots = Restaurant.all.paginate(page: params[:page], per_page: 20)
        end
        render json: @spots 
    end
    
    def reviews 
        @reviews = []
        if params[:id].blank?
            render json: @reviews 
            return 
        end
        page = 1
        
        if params[:page]
           page = params[:page] 
        end
        
        @item = Restaurant.find(params[:id])
        if @item 
            @reviews = Post.where(restaurant: @item).all.paginate(page: params[:page], per_page: 20)
        end 
        
        render json: @reviews 
    end
    
    ## auth
    def login
        @response = { 'success': false }
        
        if request.post? or request.get?
            if params[:account].blank? or params[:password].blank?
                render json: @response
                return
            end
        
            account = params[:account] 
            password = params[:password]
              
            user = User.find_by_email(account)
            if user and user.valid_password?(password)
                generate_token(user)
                @response['token'] = @mobile_session.session_token
                @response['user'] = user 
                @response['success'] = true 
            end
        end
        
        render json: @response
        return
    end
    
    def facebook
        @response = { 'success': false }
        
        if request.post? or request.get?
            if params[:oauth_token].blank?
                render json: @response
                return
            end
            
            token = params[:oauth_token]
            
            begin
                @graph = Koala::Facebook::API.new(token)
                user_object = @graph.get_object("me")
                puts user_object 
                uid = user_object['id'] 
                user = User.find_by(uid: uid)
                if user 
                    generate_token(user)
                    @response['token'] = @mobile_session.session_token
                    @response['user'] = user 
                    @response['success'] = true 
                end
            rescue
            end
        end
        
        render json: @response
        return
    end
    
    
    ## 푸시 토큰
    def push
        @response = { 'success': false }
        if params[:push]
            @token.user.push_token = params[:push]
            @token.user.save
            @response['success'] = true 
        end
        render json: @response
    end
    
    ## 푸시 발송
    def push_send
        gcm = GCM.new("AIzaSyC8PsFadzZBJ49OTrjhdx5r-TeS0k5OG64")
        registration_ids= []
        
        users = User.where.not(push_token: [nil, ""]).all
        for user in users 
            registration_ids.push(user.push_token)
            puts user.push_token
        end
        
        options = {data: {title: "포켓몬 발견!", body:"근처에서 피카츄가 발견되었다!"}, collapse_key: "123456"}
        @response = gcm.send(registration_ids, options) 
        render json: @response
    end
    
    private 
    def generate_token(user)
        UserSession.where(user: user).update_all(active: false)
        
        session_token = Digest::SHA2.hexdigest(user.id.to_s) + SecureRandom.base64(24)
        
        @mobile_session = UserSession.new 
        @mobile_session.user = user 
        @mobile_session.session_token = session_token
        @mobile_session.active = true 
        @mobile_session.save 
    end
    
    ## 로그인 체크 
    def verify_session_token
        @token = UserSession.where(session_token: params[:token]).where(active: true).first
        if not @token 
           render json: [] 
        end
    end
end
