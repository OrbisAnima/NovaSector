import {
  Box,
  Button,
  Divider,
  Flex,
  Input,
  NoticeBox,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const MechpadControl = (props) => {
  const { topLevel } = props;
  const { act, data } = useBackend();
  const { pad_name, connected_mechpad, pad_active, mechonly } = data;
  return (
    <Section
      title={
        <Input
          value={pad_name}
          width="200px"
          onBlur={(value) =>
            act('rename', {
              name: value,
            })
          }
        />
      }
      level={topLevel ? 1 : 2}
      buttons={
        <Button
          icon="times"
          content="Remove"
          color="bad"
          onClick={() => act('remove')}
        />
      }
    >
      {(!connected_mechpad && (
        <Box color="bad" textAlign="center">
          No Launch Pad Connected.
        </Box>
      )) || (
        <Button
          fluid
          icon="upload"
          disabled={!pad_active}
          content={mechonly ? 'Launch (Mech Only)' : 'Launch'}
          color={mechonly ? 'default' : 'good'}
          textAlign="center"
          onClick={() => act('launch')}
        />
      )}
    </Section>
  );
};

export const MechpadConsole = (props) => {
  const { act, data } = useBackend();
  const { mechpads = [], selected_id } = data;
  return (
    <Window width={475} height={130}>
      <Window.Content>
        {(mechpads.length === 0 && (
          <NoticeBox>No Pads Connected</NoticeBox>
        )) || (
          <Section>
            <Flex minHeight="70px">
              <Flex.Item width="140px" minHeight="70px">
                {mechpads.map((mechpad) => (
                  <Button
                    fluid
                    ellipsis
                    key={mechpad.name}
                    content={mechpad.name}
                    selected={selected_id === mechpad.id}
                    color="transparent"
                    onClick={() =>
                      act('select_pad', {
                        id: mechpad.id,
                      })
                    }
                  />
                ))}
              </Flex.Item>
              <Flex.Item minHeight="100%">
                <Divider vertical />
              </Flex.Item>
              <Flex.Item grow={1} basis={0} minHeight="100%">
                {(selected_id && <MechpadControl />) || (
                  <Box>Please select a pad</Box>
                )}
              </Flex.Item>
            </Flex>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
