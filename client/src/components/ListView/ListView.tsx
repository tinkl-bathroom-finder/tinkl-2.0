import React from "react";
import { useDispatch, useSelector } from "react-redux";

// Actions
import { toggleDetailsScreen } from "../../redux/reducers/tinklOptionsReducer";
import { setBathroomID } from "../../redux/reducers/tinklOptionsReducer";

//Types
import { TinklRootState } from "../../redux/types/TinklRootState";
import { BathroomType } from "../../redux/types/BathroomType";

//MUI Icons
import ThumbUpOutlinedIcon from "@mui/icons-material/ThumbUpOutlined";
import ThumbDownOutlinedIcon from "@mui/icons-material/ThumbDownOutlined";
import BabyChangingStationOutlinedIcon from "@mui/icons-material/BabyChangingStationOutlined";
import AccessibleForwardOutlinedIcon from "@mui/icons-material/AccessibleForwardOutlined";
import TransgenderOutlinedIcon from "@mui/icons-material/TransgenderOutlined";
// import NearMeOutlinedIcon from "@mui/icons-material/NearMeOutlined";
import Man4Icon from "@mui/icons-material/Man4";

import { Button } from "@mui/material";
import { SearchBar } from "../LeafletMap/SearchBar";

//CSS
import './listView.css';

export const ListView: React.FC = () => {
    const dispatch = useDispatch();
    const bathroomData = useSelector((state: TinklRootState) => state.bathroomData);

    const handleShowDetails = (bathroom: BathroomType) => {
        console.log('bathroom.id: ', bathroom.id)
        dispatch(setBathroomID(bathroom.id))
        dispatch(toggleDetailsScreen());
    }

    return (
        <div className="listViewContainer">
            {/* <SearchBar/> */}
            {bathroomData.map((bathroom) => (
                // <li key={`${bathroom.api_id}${bathroom.name}`}>{bathroom.name} - {bathroom.city}</li>
                <div className="card" key={bathroom.api_id}>
                    <img className="listViewPhoto" src="https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=AdDdOWr4H6cqnrtOKwnyErfhoEsZ8Ls0vansi3kCODRWU6LBrQMU0x_NotaLQ8kLbTw3s9N4fFXDKJjbgwvW4GdXFEdq9AXZCuAdllbd26ca5MIVCtMjxi3Wd_f67hlaII4YpTpfJtR_7Qq0wTl5qqm6IkPDPF8oEG2qTgKklzXGX3B7TX8x&key=AIzaSyBFwRK-YKSXb77BVXLDSG5koH_D1jFJ-Rk" />
                    
                        <h4>{bathroom.name}</h4>
                        <p className="street">{bathroom.street}</p>
                        <p className="city-state">{bathroom.city}, {bathroom.state}</p>
                        <div className="listViewRatingContainer">
                            <div><a><ThumbUpOutlinedIcon /></a>
                                <p>{bathroom.upvotes}</p> </div>

                            <div><a><ThumbDownOutlinedIcon /></a>
                                <p>{bathroom.downvotes}</p></div>
                    {/* <Button size="small" variant="outlined" onClick={() => handleShowDetails(bathroom)}>Details</Button> */}
                    </div>
                    <div className="listViewDetails">
                        {bathroom.unisex && <TransgenderOutlinedIcon aria-label="Unisex" />}
                        {bathroom.is_single_stall && <Man4Icon aria-label="Single Stall" />}
                        {bathroom.changing_table && <BabyChangingStationOutlinedIcon aria-label="Baby Changing Station" />}
                        {bathroom.accessible && <AccessibleForwardOutlinedIcon aria-label="Accessible" />}
                        
                    </div>
                    <div className="distance">{bathroom.distance_in_miles.toFixed(1)} mi.</div>
                </div>

            ))}

        </div>
    )
}