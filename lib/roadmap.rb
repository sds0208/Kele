module Roadmap    
    def get_roadmap(roadmap_id)
        response = self.class.get("https://www.bloc.io/api/v1/roadmaps/#{roadmap_id}", headers: { "authorization" => @auth_token })
        @roadmap = JSON.parse(response.body)
    end
    
    def get_checkpoint(checkpoint_id)
        response = self.class.get("https://www.bloc.io/api/v1/checkpoints/#{checkpoint_id}", headers: { "authorization" => @auth_token })
        @checkpoints = JSON.parse(response.body)
    end  
end    