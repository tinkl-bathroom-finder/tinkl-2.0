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

            {bathroomData.map((bathroom) => (
                // <li key={`${bathroom.api_id}${bathroom.name}`}>{bathroom.name} - {bathroom.city}</li>
                <div className="listViewCard" key={bathroom.api_id}>
                    <div className="listViewCardHeader">
                        <h4>{bathroom.name}</h4>
                        <div className="listViewRatingContainer">
                            <div><a><ThumbUpOutlinedIcon /></a>
                                <p>{bathroom.upvotes}</p> </div>

                            <div><a><ThumbDownOutlinedIcon /></a>
                                <p>{bathroom.downvotes}</p></div>
                        </div>
                    </div>
                    <div className="listViewDetails">
                        {bathroom.unisex && <TransgenderOutlinedIcon aria-label="Unisex" />}
                        {bathroom.is_single_stall && <Man4Icon aria-label="Single Stall" />}
                        {bathroom.changing_table && <BabyChangingStationOutlinedIcon aria-label="Baby Changing Station" />}
                        {bathroom.accessible && <AccessibleForwardOutlinedIcon aria-label="Accessible" />}
                        {bathroom.distance_in_miles.toFixed(1)} mi.
                    </div>
                    <Button size="small" variant="outlined" onClick={() => handleShowDetails(bathroom)}>Details</Button>
                </div>

            ))}

        </div>
    )
}