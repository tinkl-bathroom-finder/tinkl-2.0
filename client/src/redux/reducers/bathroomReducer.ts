import { PayloadAction, createSlice } from "@reduxjs/toolkit";

import { BathroomType } from "../types/BathroomType";

const initialState = [] as BathroomType[];

const bathroomSlice = createSlice({
    name: 'bathroomData',
    initialState: initialState,
    reducers: {
        setAllBathroomData(_, action: PayloadAction<BathroomType[]>) {
            console.log('setAllBathroomData', typeof action.payload);
            return action.payload;

        }
    }
});

export const {
    setAllBathroomData,
} = bathroomSlice.actions;

export default bathroomSlice.reducer;