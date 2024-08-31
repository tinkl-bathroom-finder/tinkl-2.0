import { PayloadAction, createSlice } from "@reduxjs/toolkit";

import { BathroomType } from "../types/BathroomType";

const initialState: BathroomType[] = [];

const bathroomSlice = createSlice({
    name: 'bathroomData',
    initialState: initialState,
    reducers: {
        setAllBathroomData(state, action: PayloadAction<BathroomType[]>) {
            return state = action.payload;

        }
    }
});

export const {
    setAllBathroomData,
} = bathroomSlice.actions;

export default bathroomSlice.reducer;