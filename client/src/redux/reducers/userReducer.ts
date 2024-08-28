import { PayloadAction, createSlice } from "@reduxjs/toolkit";

import { UserType } from "../types/UserType";

const initialState: UserType = {
    username: '',
    is_admin: false,
    is_removed: false,
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
            state = action.payload;
        }
    }
});

export const {
    setUser
} = userSlice.actions;

export default userSlice.reducer;