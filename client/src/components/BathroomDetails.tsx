import React from "react";
import { useSelector, useDispatch } from "react-redux";

// Components
import { IPeedHereButton } from "./LeafletMap/MapInfoWindow/IPeedHereButton";
import { BusinessHours } from "./BusinessHours";
import { Comments } from "./Comments";

//Functions
import { stringifyDate } from "../modules/stringifyDate";

// MUI Icons
import {
  AccessibleForwardOutlined,
  BabyChangingStationOutlined,
  Man4,
  Public,
  ThumbUpOutlined,
  ThumbDownOutlined,
  TransgenderOutlined,
  Close,
  FavoriteBorderOutlined,
  OutlinedFlag
} from "@mui/icons-material";

//Modules
import { openInMaps } from "../modules/openInMaps";

//Types
import { TinklRootState } from "../redux/types/TinklRootState";
import { BathroomType } from "../redux/types/BathroomType";

//Actions
import { toggleDetailsScreen } from "../redux/reducers/tinklOptionsReducer";


export const BathroomDetails: React.FC = () => {
  const options = useSelector((state: TinklRootState) => state.options);
  const bathroomData: BathroomType[] = useSelector((state: TinklRootState) => state.bathroomData);
  const selectedBathroom = bathroomData.filter(function (br) { return br.id === options.selectedBathroomID })[0]
  const dispatch = useDispatch();

  const handleClose = () => {
    dispatch(toggleDetailsScreen());
  }

  return (
    <div
      style={{
        position: 'relative',
        left: '7%',
        top: '10%',
        width: '85%',
        height: '75%',
        border: '1px solid black',
        background: 'white',
        borderRadius: 8,
      }}
    >
      <div
        onClick={handleClose}
        style={{ position: 'relative' }}>
        <Close
          sx={{
            position: 'absolute',
            top: '-10px',
            right: '-7px',
            background: 'white',
            color: 'black',
            width: '35px',
            height: '35px',
            cursor: 'pointer',
            borderRadius: 18,
            border: '0.01rem solid black',
          }}
        />
      </div>
      <div
        style={{
          marginLeft: '0.5rem',
          marginTop: '1rem',
        }}
      >
        <div style={{ marginLeft: '0.5rem' }}>
          <p className="updated">  {`Updated ${stringifyDate(selectedBathroom.updated_at)}`}</p>
        </div>

        <div
          style={{
            // display: 'flex',
            marginLeft: '0.5rem',
            marginRight: '1rem',
          }}
        >

          <div
            style={{
              display: 'flex',
              flexDirection: 'row',
              alignItems: 'center',
              justifyContent: 'space-between',
            }}
          >
            <h3>{selectedBathroom.name}</h3>
            <FavoriteBorderOutlined />
          </div>
          <div onClick={() => openInMaps(selectedBathroom.name + selectedBathroom.street)} style={{
            cursor: 'pointer',
            color: 'blue',
            textDecoration: 'underline',
            marginTop: 5,
          }}>
            <h3>{selectedBathroom.street}</h3>
            <h3>{selectedBathroom.city}, {selectedBathroom.state}</h3>
          </div>

          <div
            style={{
              marginTop: '1rem',
              marginBottom: '1rem',
            }}
          >
            {selectedBathroom.public &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <Public /><p>Public</p>
              </div>
            }
            {selectedBathroom.unisex &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <TransgenderOutlined /><p>Unisex</p>
              </div>
            }
            {selectedBathroom.changing_table &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <BabyChangingStationOutlined /><p>Changing Table</p>
              </div>
            }
            {selectedBathroom.accessible &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <AccessibleForwardOutlined /><p>Accessible</p>
              </div>
            }
            {selectedBathroom.is_single_stall &&
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <Man4 /><p>Single Stall</p>
              </div>
            }
          </div>
          <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'baseline' }}>
            <div style={{ display: 'flex', paddingRight: '0.5rem' }}>
              <ThumbUpOutlined />
              <p style={{ paddingLeft: '0.2rem' }}>
                {selectedBathroom.upvotes}
              </p>
            </div>
            <div style={{ display: 'flex', paddingRight: '0.5rem' }}>
              <ThumbDownOutlined />
              <p style={{ paddingLeft: '0.2rem' }}>
                {selectedBathroom.downvotes}
              </p>
            </div>
          </div>
        </div>

        <div style={{
          marginTop: '1rem',
          marginBottom: '1rem',
          marginLeft: '0.5rem',
        }}>
          {/* Will only show open or closed on details page if hours are available, otherwise will show "hours unavailable" */}
          {(
            selectedBathroom.day_1_open
            || selectedBathroom.day_2_open
            || selectedBathroom.day_3_open
            || selectedBathroom.day_4_open
            || selectedBathroom.day_5_open
            || selectedBathroom.day_6_open) &&
            <div
              style={{
                color: selectedBathroom.is_open ? 'green' : 'red',
                paddingBottom: '0.5rem',
              }}
            >
              <h4
                className={selectedBathroom.is_open ? "open" : "closed"}

              >{selectedBathroom.is_open ? "Open now" : "Closed"}</h4>
            </div>
          }

          <BusinessHours bathroom={selectedBathroom} />
        </div>
        <div>
          <Comments bathroom={selectedBathroom} />
        </div>
        <div style={{ display: 'flex', justifyContent: 'center', marginTop: '1rem' }}>
          <IPeedHereButton />
        </div>
        <div style={{ display: 'flex', flexDirection: 'row', alignItems: 'center', marginTop: '1rem' }}>
          <OutlinedFlag />
          <p style={{ fontSize: 12 }}>Have a concern? Let us know!</p>
        </div>
      </div>
    </div >
  );
}