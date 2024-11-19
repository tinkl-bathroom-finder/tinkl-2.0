
import { PayloadAction, createSlice } from "@reduxjs/toolkit";
import { LocationType } from "../types/UserType";

const initialState: LocationType = {
    lat: 44.9560534624369,
    lng: -93.16002444658359
}

const locationSlice = createSlice({
    name: 'location',
    initialState: initialState,
    reducers: {
        setSearchedLocation(state, action: PayloadAction<LocationType>){
            console.log('setUserLocation', action.payload);
            state.lat = action.payload.lat;
            state.lng = action.payload.lng;
        }
    }
});

export const {
    setSearchedLocation
} = locationSlice.actions;

export default locationSlice.reducer;