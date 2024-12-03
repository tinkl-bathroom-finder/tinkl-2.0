// LIKES TYPE
export interface LikeBathroomType {
    user_id: number,
    restroom_id: number,
    vote: string //says either 'upvote' or 'downvote'
}

// COMMENT TYPES
export interface PostCommentType {
    comment: string,
    restroom_id: number,
    user_id: number,
}
export interface DeleteCommentType {
    user_id: number,
    id: number
}