import React from "react";
import { useSelector } from "react-redux";

//Types
import { TinklRootState } from "../../redux/types/TinklRootState";

//MUI Icons
import ThumbUpOutlinedIcon from "@mui/icons-material/ThumbUpOutlined";
import ThumbDownOutlinedIcon from "@mui/icons-material/ThumbDownOutlined";
import BabyChangingStationOutlinedIcon from "@mui/icons-material/BabyChangingStationOutlined";
import AccessibleForwardOutlinedIcon from "@mui/icons-material/AccessibleForwardOutlined";
import TransgenderOutlinedIcon from "@mui/icons-material/TransgenderOutlined";
import Man4Icon from "@mui/icons-material/Man4";

//CSS
import './listView.css';

export const ListView: React.FC = () => {
    const bathroomData = useSelector((state: TinklRootState) => state.bathroomData);

    return (
        <div className="listViewContainer">

            {bathroomData.map((place) => (
                // <li key={`${place.api_id}${place.name}`}>{place.name} - {place.city}</li>
                <div className="listViewCard" key={place.api_id}>
                    <div className="listViewCardHeader">
                        <h4>{place.name}</h4>
                        <div className="listViewRatingContainer">
                            <div><a><ThumbUpOutlinedIcon /></a>
                                <p>{place.upvotes}</p> </div>

                            <div><a><ThumbDownOutlinedIcon /></a>
                                <p>{place.downvotes}</p></div>
                        </div>
                    </div>
                    <div className="listViewDetails">
                        {place.unisex && <TransgenderOutlinedIcon aria-label="Unisex" />}
                        {place.is_single_stall && <Man4Icon aria-label="Single Stall" />}
                        {place.changing_table && <BabyChangingStationOutlinedIcon aria-label="Baby Changing Station" />}
                        {place.accessible && <AccessibleForwardOutlinedIcon aria-label="Accessible" />}
                        {place.distance_in_miles.toFixed(1)} mi.
                    </div>

                </div>

            ))}

        </div>
    )
}