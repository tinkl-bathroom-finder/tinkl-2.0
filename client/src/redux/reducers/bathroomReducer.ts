import { PayloadAction, createSlice } from "@reduxjs/toolkit";

import { BathroomType } from "../types/BathroomType";
import { LikeBathroomType } from "../types/FeedbackTypes";

const initialState = [] as BathroomType[];

const bathroomSlice = createSlice({
    name: 'bathroomData',
    initialState: initialState,
    reducers: {
        setAllBathroomData(_, action: PayloadAction<BathroomType[]>) {
            console.log('setAllBathroomData', typeof action.payload);
            return action.payload;
        },
        addUpvote(state, action: PayloadAction<number>) {
            const bathroom = state.find((item) => item.id === action.payload);
            if (bathroom && bathroom.upvotes) {
                bathroom.upvotes += 1;
            } else if (bathroom && !bathroom.upvotes) {
                bathroom.upvotes = 1;
            }
        },
        addDownvote(state, action: PayloadAction<number>) {
            const bathroom = state.find((item) => item.id === action.payload);
            if (bathroom && bathroom.upvotes) {
                bathroom.upvotes -= 1;
            } else if (bathroom && !bathroom.upvotes) {
                bathroom.upvotes = 0;
            }
        },
    }
}
);

export const {
    setAllBathroomData,
    addUpvote,
    addDownvote,
} = bathroomSlice.actions;

export default bathroomSlice.reducer;