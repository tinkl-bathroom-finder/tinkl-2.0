import { PayloadAction, createSlice } from "@reduxjs/toolkit";

import { UserType } from "../types/UserType";

const initialState: UserType = {
    id: 0,
    username: '',
    location: {
        lat: 44.9560534624369,
        lng: -93.16002444658359
    }
}

//44.9560534624369, -93.16002444658359

const userSlice = createSlice({
    name: 'user',
    initialState: initialState,
    reducers: {
        setUser(state, action: PayloadAction<UserType>) {
            return state = action.payload;
        }
    }
});

export const {
    setUser
} = userSlice.actions;

export default userSlice.reducer;