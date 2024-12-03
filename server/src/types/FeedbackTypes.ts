export interface PostCommentType {
    comment: string,
    restroom_id: number,
    user_id: number,
}

export interface DeleteCommentType {
    user_id: number,
    id: number
}