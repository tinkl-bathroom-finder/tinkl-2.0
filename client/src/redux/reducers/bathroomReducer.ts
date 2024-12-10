import { PayloadAction, createSlice } from "@reduxjs/toolkit";

import { BathroomType } from "../types/BathroomType";
import { UpdateLikesType } from "../types/FeedbackTypes";

const initialState = [] as BathroomType[];

const bathroomSlice = createSlice({
    name: 'bathroomData',
    initialState: initialState,
    reducers: {
        setAllBathroomData(_, action: PayloadAction<BathroomType[]>) {
            console.log('setAllBathroomData', typeof action.payload);
            return action.payload;
        },
        updateLikes(state, action: PayloadAction<UpdateLikesType>) {
            console.log('Payload', action.payload);
            const item = state.find((item) => item.id === action.payload.bathroom_id);
            console.log(item);
            if (item) {
                item.upvotes = action.payload.upVotes
                item.downvotes = action.payload.downVotes;
                item.user_vote_status = action.payload.vote;
            }
        },
    }
}
);

export const {
    setAllBathroomData,
    updateLikes,
} = bathroomSlice.actions;

export default bathroomSlice.reducer;