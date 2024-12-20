export interface BathroomType {
    id: number,
    api_id: string,
    name: string,
    street: string,
    city: string,
    state: string,
    accessible: boolean,
    unisex: boolean,
    directions: string | null,
    latitude: number,
    longitude: number,
    created_at: Date,
    updated_at: Date,
    country: string,
    changing_table: boolean,
    is_removed: boolean,
    is_single_stall: boolean,
    is_multi_stall: boolean,
    is_open: boolean,
    public: boolean,
    is_flagged: boolean,
    place_id: string,
    photo_reference: string,
    distance_in_miles: number,
    weekday_text: string | null,
    day_0_open: number | null,
    day_0_close: number | null,
    day_1_open: number | null,
    day_1_close: number | null,
    day_2_open: number | null,
    day_2_close: number | null,
    day_3_open: number | null,
    day_3_close: number | null,
    day_4_open: number | null,
    day_4_close: number | null,
    day_5_open: number | null,
    day_5_close: number | null,
    day_6_open: number | null,
    day_6_close: number | null,
    day_7_open: number | null,
    day_7_close: number | null,
    upvotes: number | null,
    downvotes: number | null,
    admin_comment: string,
    user_vote_status: string,
    comments: CommentsType[]
}

interface CommentsType {
    id: number,
    content: string,
    user_id: number,
    inserted_at: Date
}