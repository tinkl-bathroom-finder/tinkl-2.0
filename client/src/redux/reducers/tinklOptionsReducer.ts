import { PayloadAction, createSlice } from "@reduxjs/toolkit";

//Type
import { TinklOptions } from "../types/TinklOptions";

const initialState: TinklOptions = {
    showLogin: false,
    showAbout: false,
    showAddBathroom: false,
    mapView: true
}

const tinklOptionsSlice = createSlice({
    name: 'options',
    initialState: initialState,
    reducers: {
        toggleLoginScreen(state) {
            state.showLogin = !state.showLogin;
        },
        toggleAboutScreen(state) {
            state.showAbout = !state.showAbout;
        },
        toggleAddbathroom(state) {
            state.showAddBathroom = !state.showAddBathroom;
        },
        toggleMapView(state) {
            state.mapView = !state.mapView;
        }
    }
});

export const {
    toggleLoginScreen,
    toggleAboutScreen,
    toggleAddbathroom,
    toggleMapView
} = tinklOptionsSlice.actions;

export default tinklOptionsSlice.reducer;