// LIKES TYPE
export interface LikeBathroomType {
    user_id: number,
    bathroom_id: number,
    vote: string //says either 'upvote' or 'downvote'
}

// COMMENT TYPES
export interface PostCommentType {
    comment: string,
    bathroom_id: number,
    user_id: number,
}
export interface DeleteCommentType {
    user_id: number,
    id: number
}

// BOOKMARK TYPE
export interface BookmarkType {
    user_id: number,
    bathroom_id: number
}

export interface UpdateLikesType {
    bathroom_id: number;
    upVotes: number;
    downVotes: number;
    vote: string;
}