import { PayloadAction, createSlice } from "@reduxjs/toolkit";

import { UserType } from "../types/UserType";
import { LocationType } from "../types/UserType";

const initialState: UserType = {
    id: 0,
    username: '',
    location: {
        lat: 44.9560534624369,
        lng: -93.16002444658359
    },
    userTime: {
        day: 0,
        hours: 0,
    }
}

//44.9560534624369, -93.16002444658359

const userSlice = createSlice({
    name: 'user',
    initialState: initialState,
    reducers: {
        setUser(_, action: PayloadAction<UserType>) {
            return action.payload;
        },
        logoutUser(state) {
            state.id = 0; state.username = '';
        },
        setUserLocation(state, action: PayloadAction<LocationType>) {
            console.log('setUserLocation', action.payload);
            state.location = action.payload;
        }
    }
});

export const {
    setUser,
    logoutUser,
    setUserLocation,
} = userSlice.actions;

export default userSlice.reducer;