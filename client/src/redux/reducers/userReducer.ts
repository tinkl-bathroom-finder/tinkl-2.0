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
        },
        logoutUser(state) {
            state.id = 0; state.username = '';

        },
    }
});

export const {
    setUser,
    logoutUser
} = userSlice.actions;

export default userSlice.reducer;